import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = ['form', 'filterIdInput', 'input', 'filterForm', 'filterInput', 'enabledWhenModifiedControl', 'disabledWhenModifiedControl'];

  handleClear(event) {
    if (event.explicitOriginalTarget.classList.contains('ti-close')) {
      event.currentTarget.dataset.hwComboboxExpandedValue = false;
      this.filterIdInputTarget.value = '';
      this.formTarget.submit();
      return;
    }
  }

  handleFocus(event) {
    if (event.explicitOriginalTarget.classList.contains('hw-combobox__handle')) {
      event.currentTarget.querySelector('input[role=combobox]').focus();
    }
  }

  updateControlsStatus(event) {
    const comboboxWrapper = event.target.closest('.hw-combobox');
    const combobox = comboboxWrapper.querySelector('input[role=combobox]');
    const filterModified = comboboxWrapper.dataset.originalValue !== combobox.value;

    if (filterModified && combobox.value) {
      this.disabledWhenModifiedControlTargets.forEach((target) => target.setAttribute('disabled', 'disabled'));
      this.enabledWhenModifiedControlTargets.forEach((target) => target.removeAttribute('disabled'));
    } else {
      this.disabledWhenModifiedControlTargets.forEach((target) => target.removeAttribute('disabled'));
      this.enabledWhenModifiedControlTargets.forEach((target) => target.setAttribute('disabled', 'disabled'));
    }
  }

  submit(event) {
    // update filter name
    if (event?.detail?.fieldName == 'filter[name]') {
      if (event?.detail?.value) {
        this.filterFormTarget.submit();
      }
      return;
    }

    // select new filter
    if (event?.detail?.fieldName == 'f') {
      if (event.detail.value) {
        window.location.href = `/filters/${event.detail.value}`;
      }
      return;
    }

    this.#copyFormToFilterForm();
    this.formTarget.submit();
  }

  updateFilter() {
    this.filterInputTargets.forEach((filterInput) => {
      const sourceInput = this.formTarget.querySelector(`[name="${filterInput.dataset.sourceName}"]`);
      const existingValues = JSON.parse(sourceInput.dataset.existingValues);
      filterInput.value = existingValues;
    });
    this.filterFormTarget.requestSubmit();
  }

  toggleFilter(event) {
    const value = event.params.value;
    const fieldName = event.params.fieldName;
    const input = this.formTarget.querySelector(`[name="${event.params.fieldName}"]`);
    const existingValues = JSON.parse(input.dataset.existingValues);
    let newValues;
    if (existingValues.includes(value)) {
      newValues = existingValues.filter((existingValue) => existingValue !== value)
    } else {
      newValues = [...existingValues, value];
    }
    input.dataset.existingValues = JSON.stringify(newValues);

    this.submit();
  }

  removeFilter(event) {
    const value = event.params.value;
    const fieldName = event.params.fieldName;
    const input = this.formTarget.querySelector(`[name="${event.params.fieldName}"]`);
    const existingValues = JSON.parse(input.dataset.existingValues);
    input.dataset.existingValues = JSON.stringify(existingValues.filter((existingValue) => existingValue !== value))

    this.submit();
  }

  #copyFormToFilterForm() {
    this.inputTargets.forEach((input) => {
      const existingValues = JSON.parse(input.dataset.existingValues);
      const comboboxInput = document.getElementById(input.name);
      if (comboboxInput) {
        const newValue = comboboxInput.value;
        input.value = [...existingValues, newValue];
      }
    });
  }
}
