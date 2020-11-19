%dw 2.0

import * from dw::SQL

output application/json
---
{
    "query":
        SELECT(queryParams.Contracts.selectKeys)
        FROM (queryParams.Contracts.objectName)
        WHERE(
            IN('AccountId', queryParams.AccountId, "'") AND (
                IN('Contact__c', queryParams.ContactId, "'") OR
                IN('Billing_Contact__c', queryParams.ContactId, "'")
            )
        )
        LIMIT(queryParams.limit)
        OFFSET(queryParams.offset),
    "parameters": PARAMS_IN('AccountId', queryParams.AccountId) ++
                PARAMS_IN('Contact__c', queryParams.ContactId) ++
                PARAMS_IN('Billing_Contact__c', queryParams.ContactId)
}