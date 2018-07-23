# BehatRestApiExtension

Behat context for testing REST API responses, extending
[MinkContext](https://github.com/Behat/MinkExtension/blob/master/doc/index.rst).
Currently it is supporting only JSON response types.
Using that extension you can make HTTP calls to your REST API
and strictly check the response status codes and contents.

## Setting up

### Step 1: Install extension

Install extenstion using [composer](https://getcomposer.org):

```
php composer.phar require "ulff/behat-rest-api-extension:^1.0"
```

### Step 2: load extension

Add following to behat.yml:

```yaml
default:
  extensions:
    Ulff\BehatRestApiExtension\ServiceContainer\BehatRestApiExtension: ~
```

## Usage

Create your own context class as an extension for base ```RestApiContext``` class:

```php
use Ulff\BehatRestApiExtension\Context\RestApiContext;

class YourContext extends RestApiContext
{
    // ...
}
```

You can list available scenario steps by command:

```
behat -di
```

## Additional steps offered by extension:

###### When I make request :method :uri
Make request specifying http method and uri.

Examples:
```
@When I make request "GET" "/api/v1/categories"
@When I make request "DELETE" "/api/v1/companies/{id}"
@When I make request "HEAD" "/api/v1/presentations/{id}"
```


###### When I make request :method :uri with following JSON content:
Make request specifying http method and uri and parameters as JSON.

Examples:
```
@When I make request "POST" "/api/v1/posts" with following JSON content:
"""
{
    "user": "user-id",
    "title": "Some title"
    "number": 12
}
"""

@When I make request "PUT" "/api/v1/users/{id}" with following JSON content:
"""
{
    "education": [
        {
            "school": "A primary school",
            "address": "Some Street 10, SomeCity"
        },
        {
            "school": "High School",
            "address": "Another Street 1, SomeCity"
        }
    ],
    "workplace": {
        "name": "A company",
        "phone": "+48 111 222 333"
    }
}
"""
```

###### When I make request :method :uri with params:
Make request specifying http method and uri and parameters as TableNode.
TableNode values can be also ParameterBag params.

Examples:
```
@When I make request "POST" "/api/v1/posts" with params:
    | user      | user-id              |
    | title     | Some title           |
    | content   | Content here         |
@When I make request "PUT" "/api/v1/users/{id}" with params:
    | user  | user-id           |
    | name  | User Name Here    |
    | email | user@email.here   |
```

###### Then the response should be JSON
Checks if the response is a correct JSON.

###### Then the response JSON should be a collection
Checks if a response JSON is a collection (array).

###### Then the response JSON collection should not be empty
Checks if a response JSON collection (array) is not empty.

###### Then the response JSON collection should be empty
Checks if a response JSON collection (array) is empty.

###### Then the response JSON should be a single object
Checks if a response JSON is a single object, not a collection (array).

###### Then the response JSON should have :property field
Checks if response JSON object has a property with given name.

Examples:
```
@Then the response JSON should have "id" field
```

###### Then the response JSON should have :property field with value :expectedValue
Checks if response JSON object has a property with given name and that property has expected value.

Examples:
```
@Then the response JSON should have "name" field with value "User name"
@Then the response JSON should have "email" field with value "user@email.com"
```

###### Then the response JSON should have :property field with null value
Checks if response JSON object has a property with given name and that property has null value.

Examples:
```
@Then the response JSON should have "end_date" field with null value"
@Then the response JSON should have "participants" field with null value
```

###### Then the response JSON should have :property field with exact value :expectedValue
Checks if response JSON object has a property with given name and that property has expected exact value (including type).

Examples:
```
@Then the response JSON should have "name" field with exact value "User name"
@Then the response JSON should have "email" field with exact value "user@email.com"
```

###### Then the response JSON should have :property field with value like :expectedValueRegexp
Checks if response JSON object has a property with given name and value matching given regexp.

Examples:
```
@Then the response JSON should have "error" field with value like "Missing param: [a-z]+"
@Then the response JSON should have "zipcode" field with value like "[0-9]{2}-[0-9]{3}"
```

###### Then the response JSON should have :property field set to :expectedValue
Checks if response JSON object has a property with given name and that property has expected BOOLEAN value.

Examples:
```
@Then the response JSON should have "has_access" field set to "false"
@Then the response JSON should have "is_valid" field set to "true"
```

###### Then the response JSON should have :property field with array :expectedArray as value
When response JSON is a single object, it checks if that object has a property with given name
and that property is exact array as given.

Examples:
```
@Then the response JSON should have "colors" field with array "['red', 'green', 'blue']" as value
@Then the response JSON should have "options" field with array "array('one', 'two')" as value
```

###### Then all response collection items should have :property field
When response JSON is a collection (array), it checks if ALL collection items have property with given name.

Examples:
```
@Then all response collection items should have "id" field
```

###### Then all response collection items should have :property field with value :expectedValue
When response JSON is a collection (array), it checks if ALL collection items have property with given name
and that properties have expected value.

Examples:
```
@Then all response collection items should have "default" field with value "1"
@Then all response collection items should have "color" field with value "red"
```

###### Then all response collection items should have :property field with exact value :expectedValue
When response JSON is a collection (array), it checks if ALL collection items have property with given name
and that properties have expected exact value (including type).

Examples:
```
@Then all response collection items should have "default" field with exact value "1"
@Then all response collection items should have "color" field with exact value "red"
```

###### Then all response collection items should have nested field :property with value :expectedValue
When response JSON is a collection (array), it checks if ALL collection items have nested property with given
path and that properties have expected value. For nesting property use "->" inside expected property name.

Examples:
```
@Then all response collection items should have "owner->personal_data->name" field with value "John"
@Then all response collection items should have "root->property" field with value "1"
```

###### Then all response collection items should have nested field :property with exact value :expectedValue
When response JSON is a collection (array), it checks if ALL collection items have nested property with given
path and that properties have expected exact value (including type). For nesting property use "->" inside expected property name.

Examples:
```
@Then all response collection items should have "owner->personal_data->name" field with exact value "John"
@Then all response collection items should have "root->property" field with exact value "1"
```

###### Then all response collection items should have :property field set to :expectedBoolean
When response JSON is a collection (array), it checks if ALL collection items have property with given name
and that properties have expected BOOLEAN value.

Examples:
```
@Then all response collection items should have "is_default" field set to "true"
@Then all response collection items should have "has_access" field set to "false"
```

###### Then the response JSON :fieldName field should be a collection
When response JSON is a single object, it checks if that object has a property with given name
and if that property is a collection (array).

Examples:
```
@Then the response JSON "settings" field should be a collection
@Then the response JSON "allowed_colors" field should be a collection
```

###### Then all nested :collectionFieldName collection items should have :nestedFieldName field
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path.

Examples:
```
@Then all nested "owners" collection items should have "user" field
@Then all nested "themes" collection items should have "font" field
```

###### Then all nested :collectionFieldName collection items should have :nestedFieldName field set to :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path and given
BOOLEAN value.

Examples:
```
@Then all nested "owners" collection items should have "has_access" field set to "false"
@Then all nested "themes" collection items should have "is_default" field set to "true"
```

###### Then all nested :collectionFieldName collection items should have :nestedFieldName field with value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path and with
given value.

Examples:
```
@Then all nested "owners" collection items should have "user" field with value "John"
@Then all nested "themes" collection items should have "font" field with value "Verdana"
```

###### Then all nested :collectionFieldName collection items should have :nestedFieldName field with exact value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path and with
given exact value (including type).

Examples:
```
@Then all nested "owners" collection items should have "user" field with exact value "John"
@Then all nested "themes" collection items should have "font" field with exact value "Verdana"
```

###### Then all nested :collectionFieldName collection items should have nested :nestedFieldName field with value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path and
given value. For nesting property use "->" inside expected property name.

Examples:
```
@Then all nested "owners" collection items should have nested "user->name" field with value "John"
@Then all nested "themes" collection items should have nested "font->color" field with value "Red"
```

###### Then all nested :collectionFieldName collection items should have nested :nestedFieldName field with exact value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and all of that collection items have nested field with given path and
given exact value (including type). For nesting property use "->" inside expected property name.

Examples:
```
@Then all nested "owners" collection items should have nested "user->name" field with value "John"
@Then all nested "themes" collection items should have nested "font->color" field with value "Red"
```

###### Then exactly one nested :collectionFieldName collection items should have :nestedFieldName field with value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and exactly one of that collection items have nested field with given path and with
given value.

Examples:
```
@Then exactly one nested "users" collection items should have "login" field with value "johny63"
@Then exactly one nested "members" collection items should have "position" field with value "leader"
```

###### Then at least one nested :collectionFieldName collection items should have :nestedFieldName field with value :expectedValue
When response JSON is a single object, it checks if that object has a property with given name, and that
property is a collection (array), and at least one of that collection items have nested field with given path and with
given value.

Examples:
```
@Then at least one nested "users" collection items should have "firstname" field with value "John"
@Then at least one nested "members" collection items should have "position" field with value "worker"
```


###### Then the response JSON should have nested :nestedFieldName field with value :expectedValue
When response JSON is a single object, it checks if that object has a property with given path and given value.
For nesting property use "->" inside expected property name.

Examples:
```
@Then the response JSON should have nested "recipient->phone_number" field with value "123456789"
```

###### Then the response JSON should have nested :nestedFieldName field with null value
When response JSON is a single object, it checks if that object has a property with given path with null value.
For nesting property use "->" inside expected property name.

Examples:
```
@Then the response JSON should have nested "forever_alone->friends" field with null value
```

###### Then the response collection should count :expectedValue items
When response JSON is a collection (array), it checks the number of items in collection.

Examples:
```
@Then the response collection should count "4" items
```

###### Then at least one of the collection items should have field :fieldName with value :expectedValue
When response JSON is a collection (array), it checks if any collection item has field with given value.

Examples:
```
Then at least one of the collection items should have field "name" with value "abcdef"
```# payever
