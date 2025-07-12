import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

  static targets = ['form', 'locations', 'styles', 'dateRanges'];

  submit(event) {
    this.formTarget.submit();
  }
}
