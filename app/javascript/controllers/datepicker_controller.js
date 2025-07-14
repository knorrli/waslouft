import * as easepick from "@easepick/bundle";
import { Controller } from "@hotwired/stimulus"

window.easepick = easepick;
window.DateTime = easepick.DateTime;

// Connects to data-controller="datepicker"
export default class extends Controller {

  static targets = ["wrapper", "input"];
  static values = {
    firstDay: { type: Number, default: 1 },
    lang: { type: String, default: "en-US" },
    dateRanges: { type: Array, default: [] },
    format: { type: String, default: "YYYY-MM-DD" },
    grid: { type: Number, default: 1 },
    calendars: { type: Number, default: 1 },
    readonly: { type: Boolean, default: false },
    inline: { type: Boolean, default: false },
    enableRange: { type: Boolean, default: true },
    rangeStartDate: String,
    rangeEndDate: String,
    rangeDelimiter: { type: String, default: " - " },
    rangeTooltip: { type: Boolean, default: false },
    enablePreset: { type: Boolean, default: true },
    preset: { type: Object },
    presetPosition: { type: String, default: "left" },
  };

  #presetPositions = ["top", "left", "right", "bottom"];
  #preset = this.#buildPreset();
  connect() {
    const element = this.hasInputTarget ? this.inputTarget : this.element;
    const wrapperTarget = this.wrapperTarget;
    const presetValue = this.presetValue;
    const activeDateRanges = this.dateRangesValue;
    const gridValue = this.gridValue;

    this.datepicker = new easepick.create({
      element: element,
      firstDay: this.firstDayValue,
      lang: this.langValue,
      format: this.formatValue,
      grid: this.gridValue,
      calendars: this.calendarsValue,
      readonly: this.readonlyValue,
      inline: this.inlineValue,
      zIndex: 1000,
      css: [
        RAILS_ASSET_URL("/easepick.min.css"),
        RAILS_ASSET_URL("/_easepick_overrides.css"),
      ],
      setup(picker) {
        picker.on('select', (e) => {
          const selectedPreset = Object.keys(presetValue).find((key) => {
            const { label, values: [start, end] } = presetValue[key];
            const startMatch = picker.getStartDate().format(picker.options.format) === start
            const endMatch = picker.getEndDate().format(picker.options.format) == end;
            return startMatch && endMatch;
          });
          const selectedRange = (selectedPreset || this.element.value);
          this.element.value = selectedRange;
          this.element.dispatchEvent(
            new CustomEvent(
              'datepicker:selection',
              {
                bubbles: true,
                detail: {
                  value: this.element.value,
                  fieldName: this.element.id
                }
              }
            )
          );
        });
        picker.on('clear', (e) => {
          inputTarget.value = '';
          inputTarget.dispatchEvent(new Event('datepicker.removal', { bubbles: true }));
        });
        picker.on('show', () => {
          const originalWidth = picker.ui.container.getBoundingClientRect().width;
          const calculatedWidth = wrapperTarget.getBoundingClientRect().width - 15;
          console.log("orig", originalWidth);
          console.log("calc", calculatedWidth);

          if (originalWidth >= calculatedWidth) {
            picker.options.grid = 1;
            console.log("small grid");
          }

          picker.ui.container.style.top = '42px';
          picker.ui.container.style.left = `-${wrapperTarget.getBoundingClientRect().left - 40}px`;
          picker.ui.container.style.right = `-${calculatedWidth}px`;
          picker.renderAll();
        });
        picker.on('view', (e) => {
          if (e.detail.view == 'PresetPluginButton') {
            const activeLabels = Object.keys(presetValue).reduce((activeLabels, key) => {
              if (activeDateRanges.includes(key)) {
                return [...activeLabels, presetValue[key].label];
              } else {
                return activeLabels;
              };
            }, []);

            if (activeLabels.includes(e.detail.target.textContent)) {
              e.detail.target.classList.add('active');
            }
          }
        });
      },
    });


    this.#setupPlugins();
    this.datepicker.renderAll();
  }

  disconnect() {
    this.datepicker.destroy();
    this.datepicker = undefined;
  }

  toggle() {
    if (this.dateRangeValue) {
      this.#clear();
    } else {
      this.datepicker.show();
    }
  }

  removeRange(event) {
    const rangeString = event.params.range;
    const newRanges = this.dateRangesValue.filter((range) => range !== event.params.range);
    this.inputTarget.value = newRanges;
    this.inputTarget.dispatchEvent(new Event('datepicker:removal', { bubbles: true }));
  }

  #clear() {
    this.dateRangeValue = "";
    this.datepicker.clear();
  }

  #setupPlugins() {
    this.#setupRangePlugin();
    this.#setupPresetPlugin();
  }

  #setupRangePlugin() {
    if (!this.rangePluginEnabled) return;

    const rangePlugin =
      this.datepicker.PluginManager.addInstance("RangePlugin");
    rangePlugin.options = {
      ...rangePlugin.options,
      delimiter: this.rangeDelimiterValue,
      tooltip: this.rangeTooltipValue,
    };

    if (this.rangeStartDateValue !== "") {
      rangePlugin.setStartDate(this.rangeStartDateValue);
    }

    if (this.rangeEndDateValue !== "") {
      rangePlugin.setEndDate(this.rangeEndDateValue);
    }

    rangePlugin.onAttach();
  }

  #setupPresetPlugin() {
    if (!this.presetPluginEnabled) return;

    if (this.rangePluginEnabled) {
      this.datepicker.options.plugins = [
        ...this.datepicker.options.plugins,
        "RangePlugin",
      ];
    } else {
      console.warn("[stimulus-easepick] Range plugin must be enabled.");
      return;
    }

    if (!this.#presetPositions.includes(this.presetPositionValue)) {
      console.warn("[stimulus-easepick] Preset position is not valid.");
      return;
    }

    const presetPlugin = this.datepicker.PluginManager.addInstance("PresetPlugin");

    presetPlugin.options = {
      customPreset: this.#preset,
      position: this.presetPositionValue,
    };

    presetPlugin.onAttach();
  }

  get rangePluginEnabled() {
    return this.enableRangeValue;
  }

  get presetPluginEnabled() {
    return this.enablePresetValue;
  }

  #buildPreset() {
    return Object.keys(this.presetValue).reduce((customPreset, key) => {
      const { label, values: [startDate, endDate] } = this.presetValue[key];
      customPreset[label] = [new DateTime(startDate, this.formatValue), new DateTime(endDate, this.formatValue)];
      return customPreset;
    }, {});
  }
}
