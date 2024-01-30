import { Application } from "@hotwired/stimulus"
import '@github/relative-time-element'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
