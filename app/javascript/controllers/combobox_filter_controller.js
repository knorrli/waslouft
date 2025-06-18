import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="combobox-filter"
export default class extends Controller {

  static values = {
    groups: { type: Array, default: [] },
    locations: { type: Array, default: [] },
    genres: { type: Array, default: [] },
  }

  static targets = ['combobox', 'groups', 'genres', 'locations'];

  connect() {
  }

  toggleTag(event) {
    const context = event.params.context;
    const tag = event.params.tag;
    const existingTags = this[`${context}Value`];
    if (existingTags.includes(tag)) {
      this.removeTag(event);
    } else {
      this.#addTag(context, tag);
    }
  }

  addTagFromCombobox(event) {
    const context = event.detail.value;
    const tag = event.detail.display;
    if (context && tag) {
      this.#addTag(event.detail.value, event.detail.display);
    }
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
