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

  addTagFromButton(event) {
    this.#addTag(event.params.context, event.params.tag);
  }

  addTagFromCombobox(event) {
    this.#addTag(event.detail.value, event.detail.display);
  }

  removeTag(event) {
    const context = event.params.context;
    const target = this[`${context}Target`];
    target.value = this[`${context}Value`].filter((tag) => tag !== event.params.tag);
    target.dispatchEvent(new Event('change', { bubbles: true }));
  }

  #addTag(context, tag) {
    const target = this[`${context}Target`];
    if (!target) {
      console.error("NO INPUT");
      return;
    }

    const existingTags = this[`${context}Value`];
    if (existingTags.includes(tag)) {
      console.error("TAG ALREADY IN LIST");
      return;
    }

    target.value = [...existingTags, tag];
    target.dispatchEvent(new Event('change', { bubbles: true }));
  }

}
