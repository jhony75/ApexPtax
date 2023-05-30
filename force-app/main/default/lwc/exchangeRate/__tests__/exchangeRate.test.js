import { createElement } from "lwc";
import ExchangeRate from "c/exchangeRate";
// import { registerApexWireAdapter } from "@salesforce/sfdx-lwc-jest";
import { registerLdsTestWireAdapter } from "@salesforce/sfdx-lwc-jest";
import getLastExchangeRate from "@salesforce/apex/ExchangeRateController.getLastExchangeRate";

const mockGetLastExchangeRate = require("./data/getExchangeRate.json");

// const getLastExchangeRateAdapter = registerApexWireAdapter(getLastExchangeRate);
const getLastExchangeRateAdapter =
  registerLdsTestWireAdapter(getLastExchangeRate);

describe("c-exchange-rate", () => {
  it("displays the last exchange rate", () => {
    const element = createElement("c-exchange-rate", {
      is: ExchangeRate
    });
    document.body.appendChild(element);

    getLastExchangeRateAdapter.emit(mockGetLastExchangeRate);

    return Promise.resolve().then(() => {
      const askElement = element.shadowRoot.querySelector(".ask");
      expect(askElement.textContent).toBe("5.2493");
    });
  });
});
