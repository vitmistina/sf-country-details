import { LightningElement, api } from "lwc";

export default class TimezonesCurrentTimeList extends LightningElement {
    @api timezones;
    currentTime = Date.now();

    intervalHandle;

    connectedCallback() {
        /* eslint-disable */
        this.intervalHandle = setInterval(() => {
            this.currentTime = Date.now();
        }, 1000);
        console.log(this.intervalHandle);
        /* eslint-enable */
    }

    disconnectedCallback() {
        clearInterval(this.intervalHandle);
    }
}
