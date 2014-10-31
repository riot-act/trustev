require 'digest'

module Trustev
  class Transaction

    SERVICE_URL = 'TransactionService.svc/rest/Transaction'

    CURRENCY_CODES = %w(ADP AED AFA AFN ALK ALL AMD ANG AOA AOK AON AOR ARA ARP ARS
                        ARY ATS AUD AWG AYM AZM AZN BAD BAM BBD BDT BEC BEF BEL BGJ
                        BGK BGL BGN BHD BIF BMD BND BOB BOP BOV BRB BRC BRE BRL BRN
                        BRR BSD BTN BUK BWP BYB BYR BZD CAD CDF CHC CHE CHF CHW CLF
                        CLP CNX CNY COP COU CRC CSD CSJ CSK CUC CUP CVE CYP CZK DDM
                        DEM DJF DKK DOP DZD ECS ECV EEK EGP EQE ERN ESA ESB ESP ETB EUR EUR
                        FIM FJD FKP FRF GBP GEK GEL GHC GHP GHS GIP GMD GNE GNF GNS GQE GRD
                        GTQ GWE GWP GYD HKD HNL HRD HRK HTG HUF IDR IEP ILP ILR ILS INR IQD
                        IRR ISJ ISK ITL JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAJ
                        LAK LBP LKR LRD LSL LSM LTL LTT LUC LUF LUL LVL LVR LYD MAD MAF MDL
                        MGA MGF MKD MLF MMK MNT MOP MRO MTL MTP MUR MVQ MVR MWK MXN MXP MXV
                        MYR MZE MZM MZN NAD NGN NIC NIO NLG NOK NPR NZD OMR PAB PEH PEI PEN
                        PES PGK PHP PKR PLN PLZ PTE PYG QAR RHD ROK ROL RON RSD RUB RUR RWF
                        SAR SBD SCR SDD SDG SDP SEK SGD SHP SIT SKK SLL SOS SRD SRG SSP STD
                        SUR SVC SYP SZL THB TJR TJS TMM TMT TND TOP TPE TRL TRY TTD TWD TZS
                        UAH UAK UGS UGW UGX USD USN USS UYI UYN UYP UYU UZS VEB VEF VNC VND
                        VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XEU XFO XFU XOF XPD XPF
                        XPT XRE XSU XTS XUA XXX YDD YER YUD YUM YUN ZAL ZAR ZMK ZRN ZRZ ZWC
                        ZWD ZWL ZWN ZWR)

    COUNTRY_CODES = %w(AC AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD
                       BE BF BG BH BI BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG
                       CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE
                       EG ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN
                       GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ
                       IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC
                       LI LK LR LS LT LU LV LY MA MC MD ME MG MH MK ML MM MN MO MP MQ
                       MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NS NU
                       NZ OM PA PE PF PG PH PK PL PM PN PR PT PW PY QA RE RO RS RU RW
                       SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TA TC
                       TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ
                       VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW)

    ADDRESS_TYPES = [0, 1, 2]

    STATUS_TYPES = [0, 1, 2, 3, 5, 8]

    REASON_TYPES = [0, 1, 2, 3, 4]

    def initialize(transaction_number)
      raise Error.new('TransactionNumber is required.') if transaction_number.nil?
      @transaction_number = transaction_number
    end

    def create(transaction=nil)
      raise Error.new('Transaction options are missing') if transaction.nil?
      validate(transaction)
      Trustev.send_request SERVICE_URL, build(transaction), 'POST'
      true
    end

    def update(transaction=nil)
      raise Error.new('Transaction options are missing') if transaction.nil?
      validate(transaction)
      Trustev.send_request "#{SERVICE_URL}/#{@transaction_number}", build(transaction), 'PUT'
      true
    end

    def set_status(status, reason, comment)
      raise Error.new('Invalid Status Code') if STATUS_TYPES.index(status).nil?
      raise Error.new('Invalid Reason Code') if REASON_TYPES.index(reason).nil?
      raise Error.new('Status comment cannot be blank') if comment.nil? || comment.empty?
      body = {
        Status: status,
        Reason: reason,
        Comment: comment
      }
      Trustev.send_request "#{SERVICE_URL}/#{@transaction_number}/Status", body, 'PUT'
      true
    end

    def set_bin(bin)
      raise Error.new('BIN is required') if bin.nil?
      body = {
        BINNumber: bin
      }
      Trustev.send_request "#{SERVICE_URL}/#{@transaction_number}/BIN", body, 'PUT'
    end

    private

    def validate(transaction)
      raise Error.new('Session ID is required.') if transaction[:session_id].nil?
      unless transaction[:social_network].nil?
        raise Error.new('Social Network Type is required') if transaction[:social_network][:type].nil? && !transaction[:social_network][:id].nil?
        raise Error.new('Social Network ID is required') if transaction[:social_network][:id].nil? && !transaction[:social_network][:type].nil?
      end
      raise Error.new('Invalid Currency Code') if CURRENCY_CODES.index(transaction[:transaction_data][:currency_code]).nil?
      raise Error.new('Total Transaction Value is required') if transaction[:transaction_data][:total_transaction_value].nil?
      transaction[:transaction_data][:address].each_with_index do | address, i |
        transaction[:transaction_data][:address][i] = validate_address address
      end
      raise Error.new('Customer is required') if transaction[:customer].nil?
      transaction[:customer][:address].each_with_index do | address, i |
        transaction[:customer][:address][i] = validate_address address
      end
      raise Error.new('Customer email is required') if transaction[:customer][:email].nil? || transaction[:customer][:email].size == 0
    end

    def validate_address(address)
      address[:country_code] = 'NS' if address[:country_code].nil?
      raise Error.new('Invalid Country Code') if COUNTRY_CODES.index(address[:country_code]).nil?
      raise Error.new('Invalid Address Type') if ADDRESS_TYPES.index(address[:type]).nil?
      address
    end

    def build(transaction)
      built_transaction = {
        TransactionNumber: @transaction_number,
        TransactionData: {
          Currency: transaction[:transaction_data][:currency_code],
          TotalDelivery: transaction[:transaction_data][:total_delivery] || 0,
          TotalBeforeTax: transaction[:transaction_data][:total_before_tax] || 0,
          TotalDiscount: transaction[:transaction_data][:total_discount] || 0,
          TotalTax: transaction[:transaction_data][:total_tax] || 0,
          TotalTransactionValue: transaction[:transaction_data][:total_transaction_value],
          Timestamp: "\/Date(#{transaction[:transaction_data][:timestamp]})\/"
        },
        Customer: {
          FirstName: transaction[:customer][:first_name] || ' ',
          LastName: transaction[:customer][:last_name] || ' ',
          PhoneNumber: transaction[:customer][:phone_number] || '0000',
          Email: []
        },
        SessionId: transaction[:session_id]
      }

      built_transaction[:Customer][:DateOfBirth] =
        "\/Date(#{transaction[:customer][:dob]})\/" unless transaction[:customer][:dob].nil?

      unless transaction[:social_network].nil?
        built_transaction[:SocialNetwork] = {
          Type: transaction[:social_network][:type],
          Id: transaction[:social_network][:ID]
        }
      end

      unless transaction[:transaction_data][:address].nil? || transaction[:transaction_data][:address].size == 0
        built_transaction[:TransactionData][:Address] = []
        transaction[:transaction_data][:address].each do | address |
          built_transaction[:TransactionData][:Address].push(address_to_object address)
        end
      end

      unless transaction[:transaction_data][:item].nil? || transaction[:transaction_data][:item].size == 0
        built_transaction[:TransactionData][:Item] = []
        transaction[:transaction_data][:item].each do | item |
          built_transaction[:TransactionData][:Item].push({
            Name: item[:name] || ' ',
            URL: item[:url] || ' ',
            ImageURL: item[:image_url] || ' ',
            Quantity: item[:quantity] || 0,
            TotalBeforeTax: item[:total_before_tax] || 0,
            TotalDiscount: item[:total_discount] || 0,
            TotalTax: item[:total_tax] || 0,
            TotalItemValue: item[:total_item_value] || 0
        })
        end
      end

      transaction[:customer][:email].each do | email |
        built_transaction[:Customer][:Email].push({
          IsDefault: email[:is_default] || false,
          EmailAddress: email[:address] || ' '
        })
      end

      unless transaction[:customer][:address].nil? || transaction[:customer][:address].size == 0
        built_transaction[:Customer][:Address] = []
        transaction[:customer][:address].each do | address |
          address_object = address_to_object address
          address_object[:IsDefault] = address[:is_default] || false
          built_transaction[:Customer][:Address].push(address_object)
        end
      end

      built_transaction
    end

    def address_to_object(address)
      {
        Type: address[:type],
        FirstName: address[:first_name] || ' ',
        LastName: address[:last_name] || ' ',
        Address1: address[:address_1] || ' ',
        Address2: address[:address_2] || ' ',
        Address3: address[:address_3] || ' ',
        City: address[:city] || ' ',
        State: address[:state] || ' ',
        PostalCode: address[:postal_code] || ' ',
        CountryIsoA2Code: address[:country_code]
      }
    end
  end
end