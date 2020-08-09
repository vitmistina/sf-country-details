import { LightningElement, api } from "lwc";

export default class TimezoneCurrentTime extends LightningElement {
    @api timezone;
    currentTime = Date.now();
    intervalHandle;

    connectedCallback() {
        /* eslint-disable */
        this.intervalHandle = setInterval(() => {
            this.currentTime = Date.now();
        }, 1000);
        /* eslint-enable */
    }

    disconnectedCallback() {
        clearInterval(this.intervalHandle);
    }

    get currentFormattedTimeWithOffset() {
        const direction = this.timezone.substring(3, 4) === "+" ? 1 : -1;
        const hours = parseInt(this.timezone.substring(5, 7), 10);
        const minutes = parseInt(this.timezone.substring(8, 10), 10);
        const totalMsOffset = direction * (hours * 60 + minutes) * 60 * 1000;
        const msSinceEpoch = this.currentTime + totalMsOffset;

        const options = {
            hour: "numeric",
            minute: "numeric",
            second: "numeric"
        };
        return new Intl.DateTimeFormat("en-US", options).format(msSinceEpoch);
    }
}
