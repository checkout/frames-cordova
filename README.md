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


## Example Usage

First you need to initialize the plugin using your public key.
This could be either a testing key (sandbox) or a production key

Sandbox:
```javascript
cordova.plugins.Checkout.initSandboxClient("pk_test_MyTESTPublicKey", 
    function() {
        // Success, no need to do anything
    }, function (error) {
        // Error, message returned
    });
```

Production:
```javascript
cordova.plugins.Checkout.initLiveClient("pk_MyLivePublicKey", 
    function() {
        // Success, no need to do anything
    }, function (error) {
        // Error, message returned
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
    * [.generateToken(ckoCardTokenRequest, [success], [error])](#module_cko.generateToken)
* [Models](#module_models)
    * [CkoCardTokenRequest](#module_models.CkoCardTokenRequest) : <code>Object</code>
    * [CkoCardTokenResponse](#module_models.CkoCardTokenResponse) : <code>Object</code>
    * [Address](#module_models.Address) : <code>Object</code>
    * [Phone](#module_models.Phone) : <code>Object</code>


<br>

<a name="module_cko"></a>

## Checkout
<a name="module_cko.initSandboxClient"></a>

### Checkout.initSandboxClient(publickey, [success], [error])
Initialize Frames plugin in Sandbox mode


| Param | Type | Description |
| --- | --- | --- |
| publicKey | <code>string</code> | Sandbox account public key |
| [success] | <code>function</code> | Success callback |
| [error] | <code>function</code> | Error callback |

<a name="module_cko.initLiveClient"></a>

### Checkout.initLiveClient(publickey, [success], [error])
Initialize Frames plugin in Live mode


| Param | Type | Description |
| --- | --- | --- |
| publicKey | <code>string</code> | Live account public key |
| [success] | <code>function</code> | Success callback |
| [error] | <code>function</code> | Error callback |

<a name="module_cko.generateToken"></a>

### Checkout.generateToken(ckoCardTokenRequest, success, error)
Generate a payment token


| Param | Type | Description |
| --- | --- | --- |
| ckoCardTokenRequest | [<code>CkoCardTokenRequest</code>](#module_models.CkoCardTokenRequest) | payment token request object|
| success | <code>function</code> | Success callback returns [<code>CkoCardTokenResponse</code>](#module_models.CkoCardTokenResponse) |
| error | <code>function</code> | Error callback |


<a name="module_models"></a>

## Models
<a name="module_models.CkoCardTokenRequest"></a>

### CkoCardTokenRequest : <code>Object</code>
Parameters to create a payment token from a card

**Properties**

| Name | Type | Description | Required
| --- | --- | --- | --- |
| number | <code>string</code> | The card number | Required |
| expiry_month | <code>string</code> | The expiry month of the card | Required |
| expiry_year | <code>string</code> | The expiry year of the card | Required |
| cvv | <code>string</code> | The card verification value/code. 3 digits, except for Amex (4 digits) | Optional |
| name | <code>string</code> | The cardholder's name | Optional |
| billing_address | [<code>Address</code>](#module_models.Address) | The cardholder's billing address | Optional |
| phone | [<code>Phone</code>](#module_models.Address) | The cardholder's phone number | Optional |



<a name="module_models.CkoCardTokenResponse"></a>

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
| billing_address | [<code>Address</code>](#module_models.Address) | The cardholder's billing address |
| phone | [<code>Phone</code>](#module_models.Address) | The cardholder's phone number |


<a name="module_models.Address"></a>

### Address : <code>Object</code>

**Properties**

| Name | Type | Description |
| --- | --- | --- |
| address_line1 | <code>string</code> | The first line of the address |
| address_line2 | <code>string</code> | The second line of the address |
| city | <code>string</code> | The address city |
| state | <code>string</code> | The address state |
| zip | <code>string</code> | The address zip/postal code |
| country | <code>string</code> | The two-letter ISO country code of the address |


<a name="module_models.Phone"></a>

### Phone : <code>Object</code>

**Properties**

| Name | Type | Description |
| --- | --- | --- |
| country_code | <code>string</code> | The international country calling code. Required for some risk checks |
| number | <code>string</code> | The phone number |

<br>
