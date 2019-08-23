# shax

`shax` is a Ruby gem that makes it easy to parse XML. Helpful for use with SOAP, etc.

## Examples

Parsing this XML snippet:

```ruby
xml = Shax.load <<~""
  <x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:cf="http://schemas.datacontract.org/2004/07/CF.Gateway.FIS.Dto">
      <x:Header/>
      <x:Body>
          <tem:TransHistDetailInquiry>
              <tem:request>
                  <cf:CustomerNumber>ABC123</cf:CustomerNumber>
                  <cf:ComplementDate>343434</cf:ComplementDate>
                  <cf:ComplementTime>767676</cf:ComplementTime>
                  <cf:StakeholderID>XYZPDQ</cf:StakeholderID>
              </tem:request>
              <tem:cfGatewayID>ClientName</tem:cfGatewayID>
              <tem:cfServiceKey>SecretKeyGoesHere</tem:cfServiceKey>
          </tem:TransHistDetailInquiry>
      </x:Body>
  </x:Envelope>

Shax.show xml
```

Produces the following hash:

```text
{
  "Envelope" => {
    "Header" => "",
    "Body" => {
      "TransHistDetailInquiry" => {
        "request" => {
          "CustomerNumber" => "ABC123",
          "ComplementDate" => "343434",
          "ComplementTime" => "767676",
          "StakeholderID" => "XYZPDQ",
        },
        "cfGatewayID" => "ClientName",
        "cfServiceKey" => "SecretKeyGoesHere",
      },
    },
  },
}
```
