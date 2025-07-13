import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = ['form', 'input', 'locations', 'styles', 'dateRanges'];

  submit(event) {
    this.inputTargets.forEach((input) => {
      const existingValues = JSON.parse(input.dataset.existingValues);
      const newValue = document.getElementById(input.name).value;
      input.value = [...existingValues, newValue];
    });

    this.formTarget.submit();
  }

  removeFilter(event) {
    const value = event.params.value;
    const fieldName = event.params.fieldName;
    const input = event.target.closest('#filter-form').querySelector(`[name="${event.params.fieldName}"]`);
    const existingValues = JSON.parse(input.dataset.existingValues);
    input.dataset.existingValues = JSON.stringify(existingValues.filter((existingValue) => existingValue !== value))

    this.submit();
  }
}
