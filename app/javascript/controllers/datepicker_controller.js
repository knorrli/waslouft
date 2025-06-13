import * as easepick from "@easepick/bundle";
import { Controller } from "@hotwired/stimulus"

window.easepick = easepick;

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["wrapper", "input"];
  static values = {
    firstDay: { type: Number, default: 1 },
    lang: { type: String, default: "en-US" },
    dateRange: { type: String },
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
    presetPosition: { type: String, default: "left" },
  };

  #presetPositions = ["top", "left", "right", "bottom"];

  connect() {
    const element = this.hasInputTarget ? this.inputTarget : this.element;

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
          this.element.dispatchEvent(new Event('change', { bubbles: true }));
        });
        picker.on('clear', (e) => {
          this.element.dispatchEvent(new Event('change', { bubbles: true }));
        });
        picker.on('view', (e) => {
          console.log(e.detail.view);
          if (e.detail.view == 'PresetPluginButton') {
            const startDate = picker.getStartDate();
            const endDate = picker.getEndDate();
            console.log("start date", startDate?.getTime());
            console.log("end date", endDate?.getTime());
            // if (e.detail.target.classList.contains('start') && e.detail.target.classList.contains('end')) {
            //   if (endDate?.getTime()?.toString() === e.detail.target.dataset.end) {
            //   e.detail.target.classList.add('active');
            //   }
            if (startDate?.getTime()?.toString() === e.detail.target.dataset.start && endDate?.getTime()?.toString() === e.detail.target.dataset.end) {
              e.detail.target.classList.add('active');
            }
          }
        });
      }
    });

    this.#setupPlugins();

    if (this.dateRangeValue) {
      const [ startDate, endDate ] = this.dateRangeValue.split(this.rangeDelimiterValue);
      this.datepicker.setDateRange(startDate, endDate);
    }

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

  #clear() {
    this.wrapperTarget.classList.remove('active');
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

    const now = new Date();
    let today = new Date(now.getFullYear(), now.getMonth(), now.getDay()); today.setDate(now.getDate());
    let tomorrow = new Date(now.getFullYear(), now.getMonth(), now.getDay()); tomorrow.setDate(now.getDate() + 1);
    let currentWeekendStart = new Date(now.getFullYear(), now.getMonth(), now.getDay()); currentWeekendStart.setDate(now.getDate() + (6+((1*7)-now.getDay())));
    let currentWeekendEnd = new Date(now.getFullYear(), now.getMonth(), now.getDay()); currentWeekendEnd.setDate(now.getDate() + (0+((2*7)-now.getDay())));
    let startOfNextWeek = new Date(now.getFullYear(), now.getMonth(), now.getDay()); startOfNextWeek.setDate(now.getDate() + (1+((1*7)-now.getDay())));
    let endOfNextWeek = new Date(now.getFullYear(), now.getMonth(), now.getDay()); endOfNextWeek.setDate(now.getDate() + (0+((2*7)-now.getDay())));
    let nextWeekendStart = new Date(now.getFullYear(), now.getMonth(), now.getDay()); nextWeekendStart.setDate(now.getDate() + (6+((2*7)-now.getDay())));
    let nextWeekendEnd = new Date(now.getFullYear(), now.getMonth(), now.getDay()); nextWeekendEnd.setDate(now.getDate() + (0+((3*7)-now.getDay())));
    let firstDayOfCurrentMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    let lastDayOfCurrentMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);
    let firstDayOfNextMonth = new Date(now.getFullYear(), now.getMonth() + 1, 1);
    let lastDayOfNextMonth = new Date(now.getFullYear(), now.getMonth() + 2, 0);

    presetPlugin.options = {
      customPreset: {
        'Heute': [today, today],
        'Morgen': [tomorrow, tomorrow],
        'dieses Wochenende': [currentWeekendStart, currentWeekendEnd],
        'nächste Woche': [startOfNextWeek, endOfNextWeek],
        'nächstes Wochenende': [nextWeekendStart, nextWeekendEnd],
        'aktueller Monat': [firstDayOfCurrentMonth, lastDayOfCurrentMonth],
        'nächster Monat': [firstDayOfNextMonth, lastDayOfNextMonth]
      },
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
}
