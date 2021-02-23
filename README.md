# Cordova Checkout Plugin
A Cordova plugin to use Checkout Frames for Android & iOS.

## Installation
#### From NPM (not yet published)
```shell
cordova plugin add cordova-plugin-checkout
```

#### From Git
Clone this repo and run:
```shell
cordova plugin add /path/to/cloned/repo
```


## Usage

First you need to initialize the plugin using your public key.
This could be either a testing key (sandbox) or a production key

Sandbox:
```javascript
cordova.plugins.Checkout.initSandboxClient("pk_test_MyTESTPublicKey", 
    function() {
        // Success;
    }, function (error) {
        // Error
    });
```

Production:
```javascript
cordova.plugins.Checkout.initLiveClient("pk_MyLivePublicKey", 
    function() {
        // Success;
    }, function (error) {
        // Error
    });
```

Now you can start tokenizing credit/debit cards.

```javascript
var ckoCardTokenRequest = {
    number: "4543474002249996",
    expiry_month: 6,
    expiry_year: 2025,
    name: "Bruce Wayne",
    cvv: "956",
    billing_address: {
        address_line1: "Checkout.com",
        address_line2: "90 Tottenham Court Road",
        city: "London",
        state: "London",
        zip: "W1T 4TJ",
        country: "GB"
    },
    phone: {
        country_code: "+1",
        number: "4155552671"
    }
};

function onSuccess(tokenResponse) {
    console.log('Tokenization successful', tokenResponse);
}

function onError(errorMessage) {
    console.log('Error generating token', errorMessage);
}

cordova.plugins.Checkout.generateToken(ckoCardTokenRequest, onSuccess, onError);
```

Example of TokenResponse:
```javascript
{
    type: "card",
    token: "tok_ubfj2q76miwundwlk72vxt2i7q",
    expires_on: "2019-08-24T14:15:22Z",
    expiry_month: 6,
    expiry_year: 2025,
    scheme: "VISA",
    last4: "9996",
    bin: "454347",
    card_type: "Credit",
    card_category: "Consumer",
    issuer: "GOTHAM STATE BANK",
    issuer_country: "US",
    product_id: "F",
    product_type: "CLASSIC",
    billing_address: {
        address_line1: "Checkout.com",
        address_line2: "90 Tottenham Court Road",
        city: "London",
        state: "London",
        zip: "W1T 4TJ",
        country: "GB"
    },
    phone: {
        country_code: "+1",
        number: "4155552671"
    },
    name: "Bruce Wayne"
}
```

Once you get the token, you can later use it to [request a payment](https://api-reference.checkout.com/#operation/requestAPaymentOrPayout), without you having to process or store any sensitive information.


## Documentation


* [Checkout](#module_cko)
    * [.initSandboxClient(publicKey, [success], [error])](#module_cko.initSandboxClient)
    * [.initLiveClient(publicKey, [success], [error])](#module_cko.initLiveClient)
    * [.generateToken(ckoCardTokenRequest, success, error)](#module_cko.generateToken)
    * [.CkoCardTokenRequest](#module_cko.CkoCardTokenRequest) : <code>Object</code>
    * [.CkoCardTokenResponse](#module_cko.CkoCardTokenResponse) : <code>Object</code>


<br>
<br>

<a name="module_cko"></a>

## Checkout
<a name="module_cko.initSandboxClient"></a>

### Checkout.initSandboxClient(publickey, [success], [error])
Initialize Frames plugin in Sandbox mode


| Param | Type | Description |
| --- | --- | --- |
| publicKey | <code>string</code> | Channel public key |
| [success] | <code>function</code> | Success callback |
| [error] | <code>function</code> | Error callback |

<a name="module_cko.generateToken"></a>

### Checkout.generateToken(ckoCardTokenRequest, success, error)
Generate a payment token


| Param | Type | Description |
| --- | --- | --- |
| ckoCardTokenRequest | [<code>CkoCardTokenRequest</code>](#module_cko.CkoCardTokenRequest) | payment token request object|
| success | <code>function</code> | Success callback returns [<code>CkoCardTokenResponse</code>](#module_cko.CkoCardTokenResponse) |
| error | <code>function</code> | Error callback |

<a name="module_cko.CkoCardTokenRequest"></a>

### CkoCardTokenRequest : <code>Object</code>
Parameters to create a payment token from a card

**Properties**

| Name | Type | Description | Required
| --- | --- | --- | --- |
| number | <code>string</code> | The card number | Required |
| expiry_month | <code>number</code> | The expiry month of the card | Required |
| expiry_year | <code>number</code> | The expiry year of the card | Required |
| cvv | <code>string</code> | The card verification value/code. 3 digits, except for Amex (4 digits) | Optional |
| name | <code>string</code> | The cardholder's name | Optional |
| billing_address | <code>string</code> | The cardholder's billing address | Optional |
| phone | <code>string</code> | The cardholder's phone number | Optional |



<a name="module_cko.CkoCardTokenResponse"></a>

### CkoCardTokenResponse : <code>Object</code>
Object returned after successful tokenization

**Properties**

| Name | Type | Description |
| --- | --- | --- |
| type | <code>string</code> | The token type, in this case "card" |
| token | <code>string</code> | The token value |
| expires_on | <code>string</code> | The expiration datetime of the token |
| expiry_month | <code>number</code> | The expiry month of the card |
| expiry_year | <code>number</code> | The expiry year of the card |
| name | <code>string</code> | The cardholder's name |
| scheme | <code>string</code> | The card scheme |
| last4 | <code>string</code> | The last 4 digit of the card number |
| bin | <code>string</code> | The bin range of the card |
| card_type | <code>string</code> | The card type |
| card_category | <code>string</code> | The card category |
| issuer | <code>string</code> | The card issuer name |
| issuer_country | <code>string</code> | The card issuer country ISO |
| product_id | <code>string</code> | The card product id |
| product_type | <code>string</code> | The card product type |
| billing_address | <code>string</code> | The cardholder's billing address |
| phone | <code>string</code> | The cardholder's phone number |

<br>
