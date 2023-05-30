import { LightningElement, wire } from "lwc";
import getLastExchangeRate from "@salesforce/apex/ExchangeRateController.getLastExchangeRate";

export default class ExchangeRate extends LightningElement {
  @wire(getLastExchangeRate)
  exchangeRate;

  get ask() {
    if (this.exchangeRate && this.exchangeRate.data) {
      return this.exchangeRate.data;
    }
    return "Loading...";
  }
}
