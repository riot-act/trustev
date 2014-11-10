# Trustev

Ruby wrapper for Trustev API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trustev'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trustev

## Configuration
 Set the following options
 ```ruby
 # This is your Trustev Site Username (NOTE: different from Reliance Login Username).
 # It is available under the ‘View API Keys’ section of Reliance.
 Trustev.username = 'username'
 # This is your Trustev Site Password (NOTE: different from Reliance Login Password).
 Trustev.password = 'password'
 # This is your Trustev Site Shared Secret, available from Reliance.
 Trustev.shared_secret = '0f0f0f0f'
 #This is your Trustev Site Private Key, available from Reliance.
 Trustev.private_key = 'ffffffff'
 ```

## Usage

For more information on the parameters referenced below, see the [trustev API documentation](http://developers.trustev.com/#addtransaction)

### Authentication

Authentication is handled automatically. You never have to request an authentication token manually.

### Validation of Digital Signature

```ruby
 # digital_signature = Trustev::DigitalSignature.new(digital_signature, timestamp, session_id, stage_1)
 # digital_signature.valid?
 # or
 # digital_signature.invalid?
 digital_signature = Trustev::DigitalSignature.new('ae5b0c9ea554fed8080457debed0cccf832c183b3fa7794b497f5492e98a74a2',
                                                  20141028163912,
                                                  'f39767e2-0cb5-hk97-a296-4619c269d59d',
                                                  '123456.joe@bloggs.com')
 digital_signature.valid? # true
 digital_signature.invalid? # false
```

### Transaction

#### Create a new transaction

Only the following fields are required:
* transaction_number
* transaction_data.currency
* transaction_data.total_transaction_value
* transaction_data.timestamp
* customer
```ruby
 transaction = Trustev::Transaction.new('1234abcd')
 transaction.create(
   {
     social_network: {
       type: Trustev::SOCIAL_NETWORK_TYPES[:facebook],
       id: '12345678'
     },
     transaction_data: {
       currency_code: 'EUR',
       total_delivery: 10.0,
       total_before_tax: 40,
       total_discount: 10,
       total_tax: 10,
       total_transaction_value: 50.00,
       timestamp: 1391449224000,
       address: [
         {
           type: Trustev::ADDRESS_TYPES[:standard],
           first_name: 'Joe',
           last_name: 'Bloggs',
           address_1: '2011',
           address_2: 'Imaginary Way',
           address_3: '',
           city: 'Anycity',
           state: 'AnyState',
           postal_code: '123456',
           country_code: 'US'
         }
       ],
       item: [
         {
           name: 'T-Shirt',
           url: 'T-shirts.com',
           image_url: 'T-shirts.com/Trustev-T-Shirt',
           quantity: 1,
           total_before_tax: 40.0,
           total_discount: 0.0,
           total_tax: 10,
           total_item_value: 50.0
         }
       ]
     },
     customer: {
       first_name: 'John',
       last_name: 'Doe',
       phone_number: '00353861658789',
       date_of_birth: 1403256280325,
       email: [
         {
           is_default: true,
           email_address: "jondoe@mail.com"
         }
       ],
       address: [
         {
           type: Trustev::ADDRESS_TYPES[:standard],
           first_name: 'Joe',
           last_name: 'Bloggs',
           address_1: '2011',
           address_2: 'Imaginary Way',
           address_3: '',
           city: 'Anycity',
           state: 'AnyState',
           postal_code: '123456',
           country_code: 'US',
           is_default: true
         }
       ]
     },
     session_id: 'f39767e2-0cb5-hk97-a296-4619c269d59d'
   }
 )
```
 
#### Update an existing transaction

This takes the same parameters as `Trustev::transaction.create` 
```ruby
 transaction = Trustev::Transaction.new('1234abcd')
 transaction.update({...})
```

#### Set transaction status

```ruby
 # transaction.set_status(status, reason, comment)
 transaction = Trustev::Transaction.new('1234abcd')
 transaction.set_status(Trustev::STATUS_TYPES[:refunded],
                        Trustev::REASON_TYPES[:complaint],
                        'Transaction was refunded due to a complaint')
```

| Status Code | Description |
|-------------|-------------|
| 0           | Init        |
| 1           | Placed      |
| 2           | Refunded    |
| 3           | Rejected    |
| 5           | Completed   |
| 8           | Chargeback  |

| Reason Code | Description |
|-------------|-------------|
| 0           | System      |
| 1           | Fraud       |
| 2           | Complaint   |
| 3           | Remorse     |
| 4           | Other       |

Comment: This allows you to include and extra comment on the status of the transaction

See the [trustev API documentation](http://developers.trustev.com/#addtransactionstatus) for up to date codes.

#### Add transaction BIN

```ruby
 # transaction.set_bin(bin, transaction_number)
 transaction = Trustev::Transaction.new('1234abcd')
 transaction.set_bin(123456)
```

### Social

#### Add Social

```ruby
 Trustev::Social.create([
   {
     type: Trustev::SOCIAL_NETWORK_TYPES[:facebook],
     id: 780219323,
     short_term_token: 'CAAGEIkkiTM4BAHR9ar4XH4uTqK6JaOF1aIGbCBrsQgocHUh9',
     long_term_token: 'CAAGEIkkiTM4BAJyc0pMxQQAprOrNlMRODaVQgQtcvlNO7Rvab',
     short_term_expiry: 1391448969000,
     long_term_expiry: 1391449878000,
     secret: '84bcd7da0e967139652f7ce90k4c859e'
   }
 ])
```

| Social Network Type | Name     |
|---------------------|----------|
| 0                   | Facebook |
| 1                   | Twitter  |
| 2                   | Linkedin |
| 3                   | Trustev  |

See the [trustev API documentation](http://developers.trustev.com/#addprofile) for up to types.

#### Update Social

This is similar `Trustev::Social.create`, but only accepts ONE hash, instead of an array of hashes.
```ruby
 Trustev::Social.update({
   type: Trustev::SOCIAL_NETWORK_TYPES[:facebook],
   id: 780219323,
   short_term_token: 'CAAGEIkkiTM4BAHR9ar4XH4uTqK6JaOF1aIGbCBrsQgocHUh9',
   long_term_token: 'CAAGEIkkiTM4BAJyc0pMxQQAprOrNlMRODaVQgQtcvlNO7Rvab',
   short_term_expiry: 1391448969000,
   long_term_expiry: 1391449878000,
   secret: '84bcd7da0e967139652f7ce90k4c859e'
  })
```

#### Delete Social
```ruby
 # Trustev::Social.delete(social_network_type, social_network_id)
 Trustev::Social.delete(Trustev::SOCIAL_NETWORK_TYPES[:facebook], 780219323)
``` 

### Profile

#### Retrieve Raw Scores
```ruby
 # profile = Trustev::Profile.new(transaction_number)
 # profile.retrieve_scores
 Trustev::Profile.retrieve('1234abcd')
 profile.retrieve_scores
```

This returns a hash with the Trustev Score.

###### Sample Response
```ruby
 {
   Code: 200,
   Message: "Success",
   Profile: {
     Sources: [{
         Scores: [{
             Confidence : 100,
             Parameter : 0,
             Score : 73
         }],
         Source : 7
     }]
   }
 }
```

| Response Parameter   | Description                                                                                                                       |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| Code (int)           | This will be a basic HTML response code                                                                                           |
| Message (string)     | This will be a response string which should give your some basic information on the status of you response eg. “Success” or “NOK” |
| Sources (array)      | This will be an array of Trustev Scores from different Trustev Sources                                                            |
| Scores (array)       | This will be an array of Trustev Scores based on different Score parameters                                                       |
| Confidence (decimal) | This will be a Trustev Confidence which outlines Trustev’s Condfidence in the score it has returned                               |
| Parameter (int)      | This will be The Trustev parameter which the score is based on                                                                    |
| Score (decimal)      | This is the Trustev Score                                                                                                         |
| Source (int)         | This will be the TrustevProfile Score Source on which the Trustev Scores Array was based on                                       |

#### Retrieve Overall Trustev score
```ruby
 # profile = Trustev::Profile.new(transaction_number)
 # profile.get_overall_score
 Trustev::Profile.retrieve('1234abcd')
 profile.get_overall_score
```

This returns the overall Trustev score

#### Retrieve A Specific score
```ruby
 # profile = Trustev::Profile.new(transaction_number)
 # profile.get_score(source_id, parameter_id)
 Trustev::Profile.retrieve('1234abcd')
 profile.get_score(Trustev::SCORE_SOURCES[:trustev], Trustev::SCORE_PARAMETERS[:overall])
```

This returns a score from a specific source and parameter 

| Score Source | Description |
|--------------|-------------|
| 0            | Address     |
| 1            | Behavior    |
| 2            | Device      |
| 3            | Email       |
| 4            | Facebook    |
| 5            | IP          |
| 6            | Transaction |
| 7            | Trustev     |
| 8            | Velocity    |

| Parameter Code | Description |
|----------------|-------------|
| 0              | Overall     |
| 1              | Billing     |
| 2              | Delivery    |
| 3              | Input       |
| 4              | Domain      |
| 5              | Address     |
| 6              | IP          |
| 7              | Proxy       |
| 8              | VPN         |
| 9              | Value       |
| 10             | Velocity    |
| 11             | Legitimacy  |
| 12             | Pattern     |
| 13             | Hustle      |

See the [trustev API documentation](http://developers.trustev.com/#getprofile) for up to date response info.


## Contributing

1. Fork it ( https://github.com/giftcardzen/trustev/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
