import * as easepick from "@easepick/bundle";
import { Controller } from "@hotwired/stimulus"

window.easepick = easepick;
window.DateTime = easepick.DateTime;

// Connects to data-controller="datepicker"
export default class extends Controller {

  static targets = ["input", "decoy"];
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
    const element = this.hasInputTarget ? this.decoyTarget : this.element;
    const inputTarget = this.inputTarget;
    const presetValue = this.presetValue;
    const activeDateRanges = this.dateRangesValue;

    this.datepicker = new easepick.create({
      element: element,
      firstDay: this.firstDayValue,
      lang: this.langValue,
      format: this.formatValue,
      grid: this.gridValue,
      calendars: this.calendarsValue,
      readonly: this.readonlyValue,
      inline: this.inlineValue,
      css: [
        RAILS_ASSET_URL("/easepick.min.css"),
        RAILS_ASSET_URL("/easepick_overrides.css"),
      ],
      setup(picker) {
        picker.on('select', (e) => {
          const selectedPreset = Object.keys(presetValue).find((key) => {
            const { label, values: [start, end] } = presetValue[key];
            const startMatch = picker.getStartDate().format(picker.options.format) === start
            const endMatch = picker.getEndDate().format(picker.options.format) == end;
            return startMatch && endMatch;
          });
          inputTarget.value = [...activeDateRanges, (selectedPreset || this.element.value)];
          this.element.value = '';
          debugger;
          inputTarget.dispatchEvent(new Event('change', { bubbles: true }));
        });
        picker.on('clear', (e) => {
          inputTarget.value = '';
          inputTarget.dispatchEvent(new Event('change', { bubbles: true }));
        });
        picker.on('view', (e) => {
          if (e.detail.view == 'PresetPluginButton') {
            const selectedStartDate = picker.getStartDate();
            const selectedEndDate = picker.getEndDate();
            if (selectedStartDate?.getTime()?.toString() === e.detail.target.dataset.start && selectedEndDate?.getTime()?.toString() === e.detail.target.dataset.end) {
              e.detail.target.classList.add('active');
            }
          }
        });
      },
    });


    this.#setupPlugins();

    // if (this.dateRangeValue) {
    //   const [ startDate, endDate ] = this.dateRangeValue.split(this.rangeDelimiterValue);
    //   this.datepicker.setDateRange(startDate, endDate);
    // }

    this.datepicker.renderAll();
    this.decoyTarget.value = '';
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
    this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }));
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

  #getWeekday(date, weekDay, weekInFuture) {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay() + ((date.getDay() == 0 ? -6 : 1) + (weekInFuture * 7)) + weekDay).getDate();
  }
}
