import { Controller } from "@hotwired/stimulus"

// Override "lock-in" functionality of hotwire combobox
// That way, it feels more like a select tag...
import HwComboboxController from "controllers/hw_combobox_controller"

// Prevent filtering of the list when closing the listbox
HwComboboxController.prototype._lockInSelection = function() {
  // if (this._shouldLockInSelection) {
  //   this._forceSelectionAndFilter(this._ensurableOption, "hw:lockInSelection");
  // }
}
// Do not filter when forcing selection
HwComboboxController.prototype._forceSelectionAndFilter = function(option, inputType) {
  this._forceSelectionWithoutFiltering(option);
  // this._filter(inputType);
}

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = [
    'form',
    'comboboxInput',
    'queriesInput',
    'stylesInput',
    'locationsInput',
    'dateRangesInput',

    'filterIdInput',
    'filterForm',
    'filterInput',

    'enabledWhenModifiedControl',
    'disabledWhenModifiedControl',

    'queryHandle'
  ];

  switchQueryHandle(event) {
    if (event.target.value) {
      this.queryHandleTarget.classList.remove(this.queryHandleTarget.dataset.defaultHandle);
      this.queryHandleTarget.classList.add('ti-search');
    } else {
      this.queryHandleTarget.classList.add(this.queryHandleTarget.dataset.defaultHandle);
      this.queryHandleTarget.classList.remove('ti-search');
    }
  }

  addStyleOrQuery(event) {
    if (event.detail.fieldName == event.target.dataset.hwComboboxNameWhenNewValue) {
      const originalInput = document.querySelector(`[name="${event.detail.fieldName}"]`);
      originalInput.setAttribute('name', event.target.dataset.hwComboboxOriginalNameValue);
      this.#addComboboxValue(event.detail.value, this.queriesInputTarget);
    } else {
      this.#clearComboboxInput(event.detail.fieldName);
      this.#addComboboxValue(event.detail.value, this.stylesInputTarget);
    }
  }

  addLocation(event) {
    this.#clearComboboxInput(event.detail.fieldName);
    this.#addComboboxValue(event.detail.value, this.locationsInputTarget);
  }

  addDateRange(event) {
    this.#clearComboboxInput(event.detail.fieldName);
    this.#addComboboxValue(event.detail.value, this.dateRangesInputTarget);
  }

  removeStyle(event) {
    this.#removeComboboxValue(event.params.value, this.stylesInputTarget);
  }

  removeQuery(event) {
    this.#removeComboboxValue(event.params.value, this.queriesInputTarget);
  }

  removeLocation(event) {
    this.#removeComboboxValue(event.params.value, this.locationsInputTarget);
  }

  removeDateRange(event) {
    this.#removeComboboxValue(event.params.value, this.dateRangesInputTarget);
  }

  updateFilter(event) {
    if(event.detail.fieldName == 'f' && event.detail.value) {
      if (this.filterIdInputTarget.value !== event.detail.value) {
        window.location.href = `/filters/${event.detail.value}`;
      }
    } else {
      this.#submitFilterForm();
    }
  }

  clearFilter(event) {
    if (event.explicitOriginalTarget.classList.contains('ti-close')) {
      event.currentTarget.dataset.hwComboboxExpandedValue = false;
      this.filterIdInputTarget.value = '';
      this.formTarget.requestSubmit();
    }
  }

  toggleFilter(event) {
    const value = event.params.value;
    const input = this.formTarget.querySelector(`[name="${event.params.fieldName}"]`);
    const existingValues = JSON.parse(input.dataset.existingValues);
    if (existingValues.includes(value)) {
      this.#removeComboboxValue(value, input);
    } else {
      this.#addComboboxValue(value, input);
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

  #clearComboboxInput(comboboxId) {
    document.getElementById(comboboxId).value = '';
  }

  #addComboboxValue(value, target) {
    const existingValues = JSON.parse(target.dataset.existingValues);
    target.dataset.existingValues = JSON.stringify([...existingValues, value]);
    this.#submitForm();
  }

  #removeComboboxValue(value, target) {
    const existingValues = JSON.parse(target.dataset.existingValues);
    const filteredValues = existingValues.filter((existingValue) => existingValue != value);
    target.dataset.existingValues = JSON.stringify(filteredValues);

    this.#submitForm();
  }

  #submitForm() {
    this.comboboxInputTargets.forEach((input) => {
      input.value = JSON.parse(input.dataset.existingValues);
    });

    this.formTarget.requestSubmit();
  }

  #submitFilterForm() {
    this.filterInputTargets.forEach((input) => {
      const sourceInput = document.querySelector(`[name='${input.dataset.sourceName}']`);
      input.value = JSON.parse(sourceInput.dataset.existingValues);
    });

    this.filterFormTarget.requestSubmit();
  }
}
