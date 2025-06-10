import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="combobox-filter"
export default class extends Controller {

  static values = {
    genres: { type: Array, default: [] },
    locations: { type: Array, default: [] },
  }

  static targets = ['combobox', 'genres', 'locations'];

  connect() {
  }

  addTag(event) {
    const context = event.detail.value;
    const tag = event.detail.display;
    const target = this[`${context}Target`];
    if (!target) {
      console.error("NO INPUT");
      return;
    }

    target.value = [...this[`${context}Value`], tag];
    target.dispatchEvent(new Event('change', { bubbles: true }));
  }

  removeTag(event) {
    const context = event.params.context;
    const target = this[`${context}Target`];
    target.value = this[`${context}Value`].filter((tag) => tag !== event.params.tag);
    target.dispatchEvent(new Event('change', { bubbles: true }));
  }
}
