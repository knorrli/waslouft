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
    enableRange: { type: Boolean, default: false },
    rangeStartDate: String,
    rangeEndDate: String,
    rangeDelimiter: { type: String, default: " - " },
    rangeTooltip: { type: Boolean, default: true },
  };

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
        "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2/dist/index.min.css",
      ],
      setup(picker) {
        picker.on('select', (e) => {
          this.element.dispatchEvent(new Event('change', { bubbles: true }));
        }),
        picker.on('clear', (e) => {
          this.element.dispatchEvent(new Event('change', { bubbles: true }));
        })
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

  get rangePluginEnabled() {
    return this.enableRangeValue;
  }
}
