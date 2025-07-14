import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = ['form', 'filterForm', 'input', 'filterInput'];

  submit(event) {
    if (event?.detail?.fieldName == 'filter[name]') {
      if (event.detail.value) {
        window.location.href = `/filters/${event.detail.value}`;
      }
      return;
    }

    this.inputTargets.forEach((input) => {
      const existingValues = JSON.parse(input.dataset.existingValues);
      const newValue = document.getElementById(input.name).value;
      input.value = [...existingValues, newValue];
    });

    this.formTarget.submit();
  }

  updateFilter() {
    this.filterInputTargets.forEach((filterInput) => {
      const sourceInput = this.formTarget.querySelector(`[name="${filterInput.dataset.sourceName}"]`);
      const existingValues = JSON.parse(sourceInput.dataset.existingValues);
      filterInput.value = existingValues;
    });
    this.filterFormTarget.submit();
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
    debugger;
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
}
