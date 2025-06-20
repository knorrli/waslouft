import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="combobox-filter"
export default class extends Controller {

  static values = {
    locations: { type: Array, default: [] },
    styles: { type: Array, default: [] },
    genres: { type: Array, default: [] },
  }

  static targets = ['combobox', 'search', 'locations', 'styles', 'genres'];

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
    if (event.detail.fieldName == 'search') {
      this.searchTarget.value = event.detail.query;
      this.searchTarget.dispatchEvent(new Event('change', { bubbles: true }));
      return;
    }
    if (context && tag) {
      this.#addTag(event.detail.value, event.detail.display);
    }
  }

  removeSearch() {
    this.searchTarget.value = '';
    this.searchTarget.dispatchEvent(new Event('change', { bubbles: true }));
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
