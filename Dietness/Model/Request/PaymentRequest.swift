//
//  PaymentRequest.swift
//  Dietness
//
//  Created by mohamed dorgham on 16/05/2021.
//  Copyright © 2021 Dietness. All rights reserved.
//

import Foundation

// MARK: - PaymentRequest
class PaymentRequest: Codable {
    var amount: Int?
    var apiVersion: String?
    var cardThreeDSecure: Bool?
    var currency: String?
    var customer: CustomerRequest?
    var paymentRequestDescription, id: String?
    var liveMode: Bool?
    var merchantID: String?
    var metadata: Metadata?
    var method, object, product: String?
    var receipt: ReceiptRequest?
    var redirect: Redirect?
    var reference: Reference?
    var response: Response?
    var saveCard: Bool?
    var source: Source?
    var statementDescriptor, status: String?
    var threeDSecure: Bool?
    var transaction: Transaction?

    enum CodingKeys: String, CodingKey {
        case amount
        case apiVersion = "api_version"
        case cardThreeDSecure = "card_threeDSecure"
        case currency, customer
        case paymentRequestDescription = "description"
        case id
        case liveMode = "live_mode"
        case merchantID = "merchant_id"
        case metadata, method, object, product, receipt, redirect, reference, response
        case saveCard = "save_card"
        case source
        case statementDescriptor = "statement_descriptor"
        case status, threeDSecure, transaction
    }

    init(amount: Int?, apiVersion: String?, cardThreeDSecure: Bool?, currency: String?, customer: CustomerRequest?, paymentRequestDescription: String?, id: String?, liveMode: Bool?, merchantID: String?, metadata: Metadata?, method: String?, object: String?, product: String?, receipt: ReceiptRequest?, redirect: Redirect?, reference: Reference?, response: Response?, saveCard: Bool?, source: Source?, statementDescriptor: String?, status: String?, threeDSecure: Bool?, transaction: Transaction?) {
        self.amount = amount
        self.apiVersion = apiVersion
        self.cardThreeDSecure = cardThreeDSecure
        self.currency = currency
        self.customer = customer
        self.paymentRequestDescription = paymentRequestDescription
        self.id = id
        self.liveMode = liveMode
        self.merchantID = merchantID
        self.metadata = metadata
        self.method = method
        self.object = object
        self.product = product
        self.receipt = receipt
        self.redirect = redirect
        self.reference = reference
        self.response = response
        self.saveCard = saveCard
        self.source = source
        self.statementDescriptor = statementDescriptor
        self.status = status
        self.threeDSecure = threeDSecure
        self.transaction = transaction
    }
}

// MARK: - Customer
class CustomerRequest: Codable {
    var email, firstName, id, lastName: String?
    var phone: Phone?

    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case phone
    }

    init(email: String?, firstName: String?, id: String?, lastName: String?, phone: Phone?) {
        self.email = email
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.phone = phone
    }
}

// MARK: - Phone
class Phone: Codable {
    var countryCode, number: String?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case number
    }

    init(countryCode: String?, number: String?) {
        self.countryCode = countryCode
        self.number = number
    }
}

// MARK: - Metadata
class Metadata: Codable {
    var packageID, planID, userID: String?

    enum CodingKeys: String, CodingKey {
        case packageID = "packageId"
        case planID = "planId"
        case userID = "userId"
    }

    init(packageID: String?, planID: String?, userID: String?) {
        self.packageID = packageID
        self.planID = planID
        self.userID = userID
    }
}

// MARK: - Receipt
class ReceiptRequest: Codable {
    var email: Bool?
    var id: String?
    var sms: Bool?

    init(email: Bool?, id: String?, sms: Bool?) {
        self.email = email
        self.id = id
        self.sms = sms
    }
}

// MARK: - Redirect
class Redirect: Codable {
    var status, url: String?

    init(status: String?, url: String?) {
        self.status = status
        self.url = url
    }
}

// MARK: - Reference
class Reference: Codable {
    var acquirer, gateway, payment, track: String?

    init(acquirer: String?, gateway: String?, payment: String?, track: String?) {
        self.acquirer = acquirer
        self.gateway = gateway
        self.payment = payment
        self.track = track
    }
}

// MARK: - Response
class Response: Codable {
    var code, message: String?

    init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }
}

// MARK: - Source
class Source: Codable {
    var channel, id, object, paymentMethod: String?
    var paymentType, type: String?

    enum CodingKeys: String, CodingKey {
        case channel, id, object
        case paymentMethod = "payment_method"
        case paymentType = "payment_type"
        case type
    }

    init(channel: String?, id: String?, object: String?, paymentMethod: String?, paymentType: String?, type: String?) {
        self.channel = channel
        self.id = id
        self.object = object
        self.paymentMethod = paymentMethod
        self.paymentType = paymentType
        self.type = type
    }
}

// MARK: - Transaction
class Transaction: Codable {
    var amount: Int?
    var asynchronous: Bool?
    var authorizationID, created, currency: String?
    var expiry: Expiry?
    var timezone: String?

    enum CodingKeys: String, CodingKey {
        case amount, asynchronous
        case authorizationID = "authorization_id"
        case created, currency, expiry, timezone
    }

    init(amount: Int?, asynchronous: Bool?, authorizationID: String?, created: String?, currency: String?, expiry: Expiry?, timezone: String?) {
        self.amount = amount
        self.asynchronous = asynchronous
        self.authorizationID = authorizationID
        self.created = created
        self.currency = currency
        self.expiry = expiry
        self.timezone = timezone
    }
}

// MARK: - Expiry
class Expiry: Codable {
    var period: Int?
    var type: String?

    init(period: Int?, type: String?) {
        self.period = period
        self.type = type
    }
}
