Feature: Demo tests for payever
    Background:
        When I make request "POST" "/oauth/v2/token" with following JSON content:
        """
            {
                "client_id": "30801_44jezpd83a68wc4k8c8wsssco4k0w0gow4owswoc0g0oksc8o8",
                "client_secret": "9vejpbzp8k08sk0k08cg00ocsgco80ckog8s800kgwcckwss0",
                "grant_type": "http://www.payever.de/api/payment",
                "scope": "API_CREATE_PAYMENT"
            }
        """
        Then the response JSON should have "access_token" field
        And the response JSON should have "expires_in" field
        And the response JSON should have "scope" field
        And the response JSON should have "token_type" field
        And the response JSON should have "refresh_token" field
        Given save access token from the last response
        And I set access token in header

    Scenario: Fill data on Personal info page. Validation.
        When I make request "POST" "/api/payment" with following JSON content:
        """
            {
                "channel": "other_shopsystem",
                "amount": "100",
                "cart": {
                            "name": "test",
                            "price": "22",
                            "priceNetto": "33",
                            "vatRate": "44",
                            "quantity": "3",
                            "thumbnail": "https://someitem.com/thumbnail.jpg",
                            "sku": "123"
                        },
                "order_id": "900001291100",
                "currency": "USD"
            }
        """
        Then the response JSON should have "redirect_url" field
        Then save redirect uri from the last response
        And I set access token in header

        #open in browser
        When I open page with redirect URI
        Then I wait and should see "Personal info" text
        And I should see "Continue"

        When I press "Continue"
        Then I wait and should see "Enter a valid email" text

        When I type "invalidemail" in "email" field on personal info page
        And I press "Continue"
        Then I wait and should see "Enter a valid email" text

        When I type "validemail@mailinator.com" in "email" field on personal info page

        #search location by name and select from suggested list
        When I find and select "Belarus Partizanskaya" address

        And I press "Continue"
        Then I wait and should see "Billing and shipping address" text

    Scenario: Fill data on Billing and shipping address page.
        When I make request "POST" "/api/payment" with following JSON content:
        """
            {
                "channel": "other_shopsystem",
                "amount": "100",
                "fee": "10",
                "cart": {
                            "name": "test",
                            "price": "22",
                            "priceNetto": "33",
                            "vatRate": "44",
                            "quantity": "3",
                            "thumbnail": "https://someitem.com/thumbnail.jpg",
                            "sku": "123"
                        },
                "order_id": "900001291100",
                "currency": "USD",
                "city": "New York",
                "zip": "10019",
                "country": "US",
                "email": "artem.smith@mailinator.com"
            }
        """
        Then the response JSON should have "redirect_url" field
        Then save redirect uri from the last response
        And I set access token in header

        #open in browser
        When I open page with redirect URI
        Then I wait and should see "Billing and shipping address" text
        And I wait and should see "Continue" text

        When I press "Continue"
        Then I wait and should see "Enter your first name" text
        And I wait and should see "Enter your last name" text
        And I wait and should see "Enter the your street address" text
        When I type "Artem" in "first_name" field on billing address page
        When I type "Smith" in "last_name" field on billing address page
        When I type "Pobediteley street 56" in "street" field on billing address page

        When I press "Continue"

        Then I wait and should see "Payment method" text

        #TODO
    Scenario: Validation on Billing and shipped address page

    Scenario: Fill data on Payment method page and PAY
        When I make request "POST" "/api/payment" with following JSON content:
        """
            {
                "channel": "other_shopsystem",
                "amount": "100",
                "fee": "10",
                "cart": {
                            "name": "test",
                            "price": "22",
                            "priceNetto": "33",
                            "vatRate": "44",
                            "quantity": "3",
                            "thumbnail": "https://someitem.com/thumbnail.jpg",
                            "sku": "123"
                        },
                "order_id": "900001291100",
                "currency": "USD",
                "city": "New York",
                "zip": "10019",
                "first_name": "artem",
                "last_name": "smith",
                "street": "5th Ave, 342",
                "country": "US",
                "email": "artem.smith@mailinator.com"
            }
        """
        Then the response JSON should have "redirect_url" field
        Then save redirect uri from the last response
        And I set access token in header

        #open in browser
        When I open page with redirect URI
        Then I wait and should see "Payment method" text
        And I wait and should see "Pay" text

        #validation
        And I press "Pay"

        Given I switch to iframe

        Then I wait and should see "Enter card number" text
        And I should see "Enter expiration date"
        And I should see "Enter cvc"

        #validation
        When I fill in "card_number" with "4111111111111"
        And I fill in "exp_date" with "1124"
        And I fill in "cvc" with "233"

        Given I switch back to page
        And I press "Pay"
        Given I switch to iframe

        Then I wait and should see "Your card number is incorrect." text

        #pay
        When I fill in "card_number" with "4242424242424242"
        And I fill in "exp_date" with "1124"
        And I fill in "cvc" with "233"

        Given I switch back to page

        And I press "Pay"
        Then I wait and should see "Thank you! Your order has been placed" text

        And I should see "Order number"

#    //p[@class='receipt-order']//stong     text as ID

