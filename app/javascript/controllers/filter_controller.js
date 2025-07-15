import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = ['form', 'filterIdInput', 'combobox', 'input', 'filterForm', 'filterInput', 'enabledWhenModifiedControl', 'disabledWhenModifiedControl'];

  handleClear(event) {
    if (event.explicitOriginalTarget.classList.contains('ti-close')) {
      event.currentTarget.dataset.hwComboboxExpandedValue = false;
      this.filterIdInputTarget.value = '';
      this.#copyFormToFilterForm();
      this.formTarget.requestSubmit();
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

  apply(event) {
    if (!event?.detail?.value) {
      return;
    }

    // update filter name
    if (event?.detail?.fieldName == 'filter[name]') {
      this.filterFormTarget.submit();
      return;
    }

    // select filter
    if (event?.detail?.fieldName == 'f') {
      window.location.href = `/filters/${event.detail.value}`;
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

    this.#copyFormToFilterForm();

    this.formTarget.submit();
  }

  removeFilter(event) {
    const value = event.params.value.toString();
    const fieldName = event.params.fieldName;
    const input = this.formTarget.querySelector(`[name="${event.params.fieldName}"]`);
    const existingValues = JSON.parse(input.dataset.existingValues);

    const newValues = existingValues.filter((existingValue) => existingValue !== value);
    input.dataset.existingValues = JSON.stringify(newValues)
    input.value = newValues.join(',')

    this.#copyFormToFilterForm();

    this.formTarget.submit();
  }

  #copyFormToFilterForm() {
    this.comboboxTargets.forEach((combobox) => {
      const formInput = document.querySelector(`[name='${combobox.id}']`);
      if (formInput) {
        const existingValues = JSON.parse(formInput.dataset.existingValues);
        formInput.value = [...existingValues, combobox.value];
      } else {
        const alternativeFormInput = document.getElementById(`${combobox.dataset.alternativeInputId}[]`);
        const regularFormInput = document.querySelector(`[name='${combobox.dataset.alternativeInputId}']`);

        const existingValues = JSON.parse(alternativeFormInput.dataset.existingValues);
        alternativeFormInput.value = [...existingValues, combobox.value];
        regularFormInput.value = JSON.parse(regularFormInput.dataset.existingValues);
        regularFormInput.setAttribute('name', combobox.id);
      }
    });
  }
}
