import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "menu", "modal"]

  toggleMenu(event) {
    this.menuTarget.classList.toggle('is-active')
    //document.getElementById(event.target.dataset.id).classList.toggle('is-active')
  }

  closeModal(event) {
    [].forEach.call(document.getElementsByClassName('modal'), (item) => {item.classList.remove('is-active')})
    if ( document.getElementById("yield") == null) { window.location.replace("/") }
  }
  
  scrollTo({params}) {
    console.log('scrollTo')
    var getMeTo = document.getElementById(params.id);
    getMeTo.scrollIntoView({behavior: 'smooth'}, true);
  }
}
