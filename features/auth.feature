Feature: Auth
    Scenario: test1
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
        Then the response JSON should have "expires_in" field
        Then the response JSON should have "scope" field
        Then the response JSON should have "token_type" field
        Then the response JSON should have "refresh_token" field
        And print last response
        And save access token from the last response
        And I set access token in header
        When I make request "POST" "/api/payment" with following JSON content:
        """
            {
                "name": "test",
                "amount": "100",
                "fee": "10",
                "order_id": "900001291100",
                "currency": "USD",
                "description": "test desc",
                "thumbnail": "https://someitem.com/thumbnail.jpg"
            }
        """
        And print last response

        And save redirect uri from the last response
        And I make request POST for payment with redirect URL from last response with following JSON content:
        """
            {
                    "name": "test",
                    "price": "22",
                    "priceNetto": "33",
                    "vatRate": "44",
                    "quantity": "3",
                    "thumbnail": "https://someitem.com/thumbnail.jpg",
                    "sku": "123"
            }
        """
        And print last response
        And show last response

#        When I open page "http://sandbox.payever.de/oauth/v2/token"
        When I open page with redirect URI
And I wait "20"
#        When I am on "http://sandbox.payever.de/oauth/v2/token"
