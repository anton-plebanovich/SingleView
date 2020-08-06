//
//  HomeVC.swift
//  SingleView
//
//  Created by Anton Plebanovich on 1/6/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Alamofire
import APExtensions
import BaseClasses
import UIKit
import RxSwift
import RxUtils
import RxRelay

final class HomeVC: UIViewController {
    
    // ******************************* MARK: - Private Properties
    
    @EquatableFilter @BehaviorRelayBacked var asd: Int = 1
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asd = 2
        asd = 3
        asd = 3
    }
}

// ******************************* MARK: - InstantiatableFromStoryboard

extension HomeVC: InstantiatableFromStoryboard {}

// ******************************* MARK: - Debug

@propertyWrapper
struct LateInitialized<V> {
    
    var projectedValue: V?
    
    var wrappedValue: V {
        get {
            guard let value = projectedValue else {
                fatalError("value has not yet been set!")
            }
            return value
        }
        set {
            projectedValue = newValue
        }
    }
    
    init(projectedValue: V? = nil) {
        self.projectedValue = projectedValue
    }
}

extension LateInitialized: NestablePropertyWrapper {}

/// Property wrapper that stores value as an object in `UserDefaults`.
/// - warning: Supports only fixed set of types `NSData`, `NSString`, `NSNumber`, `NSDate`, `NSArray`, or `NSDictionary` and their compinations.
/// Please check `UserDefaults` documentation - https://developer.apple.com/documentation/foundation/userdefaults
@propertyWrapper
class UserDefault<V> {
    
    private let key: String
    
    var wrappedValue: V {
        get { loadValue() }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    private let loadValue: () -> V
    
    /// Removes object from the UserDefaults
    func removeFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /// Initializes `UserDefault` wrapper for storing values under the key provided.
    ///
    /// If there is no stored value at time `wrappedValue` getter is called, `defaultValue` provided is saved to defaults
    /// storage before being returned to caller.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - defaultValue: Fallback default value..
    convenience init(key: String, defaultValue: V) {
        self.init(key: key, deferredDefaultValue: { defaultValue })
    }
    
    /// Initializes `UserDefault` wrapper for storing values under the key provided.
    ///
    /// If there is no stored value at time `wrappedValue` getter is called, defaultValue provided is saved to defaults
    /// storage before being returned to caller.
    ///
    /// - Parameters:
    ///   - key: The key with which to associate the value.
    ///   - deferredDefaultValue: Fallback closure for providing default value.
    init(key: String, deferredDefaultValue: @escaping () -> V) {
        self.key = key
        loadValue = {
            if let value = UserDefaults.standard.object(forKey: key) as? V {
                return value
            } else {
                let value = deferredDefaultValue()
                UserDefaults.standard.set(value, forKey: key)
                return value
            }
        }
    }
}

// ******************************* MARK: - Equatable

extension UserDefault: Equatable where V: Equatable {
    static func == (lhs: UserDefault<V>, rhs: UserDefault<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension UserDefaults {
    /// Wheter UserDefaults has the object for the key
    func hasObject(forKey key: String) -> Bool {
        object(forKey: key) != nil
    }
    
    /// Setting `nil` for key isn't the same as removing key. This method resolves this issue.
    func properlySet(_ value: Any?, forKey key: String) {
        if let value = Utils.unwrap(value) {
            set(value, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }
}

enum Utils {
    
    /// Removes nested optionals until only one left
    static func unwrap(_ _any: Any?) -> Any? {
        guard let any = _any else { return _any }
        
        // Check if Any actually is Any?
        if let optionalAny = any as? _Optional {
            // swiftlint:disable:next property_wrapper_outer_access_is_prohibited
            return unwrap(optionalAny._value)
        } else {
            return any
        }
    }
}

/// Helper protocol
private protocol _Optional {
    var _value: Any? { get }
}

extension Optional: _Optional {
    var _value: Any? {
        switch self {
        case .none: return nil
        case .some: return self!
        }
    }
}


// ******************************* MARK: - Codable Support

extension UserDefaults {
    /// - warning: It doesn't work with primitive types.
    func setCodableValue<T: Codable>(type: T.Type, value: T?, forKey key: String) {
        guard let value = value else {
            removeObject(forKey: key)
            return
        }
        
        guard let data = value.safePropertyListEncoded() else { return }
        
        set(data, forKey: key)
    }
    
    /// - warning: It doesn't work with primitive types.
    func getCodableValue<T: Codable>(type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        if let object = type.safeCreate(propertyListData: data) {
            return object
            
        } else {
            removeObject(forKey: key)
            return nil
        }
    }
}

// ******************************* MARK: - Property List Codable

extension Encodable {
    
    /// Encodes the object into a property list and reports an error if unable.
    func safePropertyListEncoded() -> Data? {
        let encoder = PropertyListEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            return nil
        }
    }
}

extension Decodable {
    
    /// Creates object from property list data and reports error if unable.
    static func safeCreate(propertyListData: Data) -> Self? {
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode(Self.self, from: propertyListData)
        } catch {
            return nil
        }
    }
}

@propertyWrapper
struct UserDefaultCodable<V: Codable> {
    
    private let key: String
    private let defaultValue: V
    
    var wrappedValue: V {
        get { UserDefaults.standard.getCodableValue(type: V.self, forKey: key) ?? defaultValue }
        set { UserDefaults.standard.setCodableValue(type: V.self, value: newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: V) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension UserDefault: NestablePropertyWrapper {}
extension UserDefaultCodable: NestablePropertyWrapper {}

@propertyWrapper
final class BehaviorRelayBacked<V>: WrappedValueInstantiatable {
    
    let projectedValue: BehaviorRelay<V>
    
    var wrappedValue: V {
        get {
            projectedValue.value
        }
        set {
            projectedValue.accept(newValue)
        }
    }
    
    init(wrappedValue: V) {
        projectedValue = BehaviorRelay(value: wrappedValue)
    }
    
    init(projectedValue: BehaviorRelay<V>) {
        self.projectedValue = projectedValue
    }
}

// ******************************* MARK: - Equatable

extension BehaviorRelayBacked: Equatable where V: Equatable {
    static func == (lhs: BehaviorRelayBacked<V>, rhs: BehaviorRelayBacked<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

// ******************************* MARK: - Codable

extension BehaviorRelayBacked: Codable where V: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let value = try V(from: decoder)
        self.init(wrappedValue: value)
    }
    
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}


extension BehaviorRelayBacked: NestableProjectedPropertyWrapper {}

@propertyWrapper
final class EquatableFilter<V: Equatable> {
    
    @BehaviorRelayBacked private var storage: V
    
    var projectedValue: Observable<V> { $storage.asObservable() }
    
    var wrappedValue: V {
        get { storage }
        set {
            guard newValue != storage else { return }
            storage = newValue
        }
    }
    
    init(wrappedValue: V) {
        storage = wrappedValue
    }
}

extension EquatableFilter: NestablePropertyWrapper {
    func setNewValue(_ newValue: V) -> V? {
        if wrappedValue == newValue {
            return nil
        } else {
            wrappedValue = newValue
            return newValue
        }
    }
}

extension EquatableFilter: WrappedValueInstantiatable {}

protocol WrappedValueInstantiatable {
    associatedtype WrappedValue
    
    init(wrappedValue: WrappedValue)
}

protocol NestablePropertyWrapper {
    
    associatedtype WrappedValue
    
    var wrappedValue: WrappedValue { get set }
    
    mutating func setNewValue(_ newValue: WrappedValue) -> WrappedValue?
}

extension NestablePropertyWrapper {
    mutating func setNewValue(_ newValue: WrappedValue) -> WrappedValue? {
        wrappedValue = newValue
        return newValue
    }
}

protocol NestableProjectedPropertyWrapper: NestablePropertyWrapper {
    
    associatedtype ProjectedValue
    
    var projectedValue: ProjectedValue { get }
}

//@propertyWrapper
//struct PropertyWrappersApplier21<T: NestableProjectedPropertyWrapper, V: NestablePropertyWrapper> where T.WrappedValue == V.WrappedValue {
//
//    typealias ProjectedValue = T.ProjectedValue
//    typealias WrappedValue = T.WrappedValue
//
//    var projectedValue: ProjectedValue {
//        projectedWrapper.projectedValue
//    }
//
//    var wrappedValue: WrappedValue {
//        get { getWrappedValue() }
//        set { setWrappedValue(newValue) }
//    }
//
//    private let projectedWrapper: T
//    private let firstWrapper: V
//    private let getWrappedValue: () -> WrappedValue
//    private let setWrappedValue: (WrappedValue) -> Void
//
//    init(getProjectedWrapper: (WrappedValue) -> T,
//         firstWrapper: V) {
//
//        self.firstWrapper = firstWrapper
//        self.projectedWrapper = getProjectedWrapper(firstWrapper.wrappedValue)
//
//        getWrappedValue = {
//            firstWrapper.wrappedValue
//        }
//
//        setWrappedValue = { [projectedWrapper] newValue in
//            projectedWrapper.wrappedValue = newValue
//            var _newValue = projectedWrapper.newValue
//
//            if let newValue = _newValue {
//                firstWrapper.wrappedValue = newValue
//                _newValue = firstWrapper.newValue
//            } else {
//                return
//            }
//        }
//    }
//}
//
//extension PropertyWrappersApplier21 where T: WrappedValueInstantiatable {
//    init(firstWrapper: V) {
//        self.init(getProjectedWrapper: T.init(wrappedValue:),
//                  firstWrapper: firstWrapper)
//    }
//}

//extension BehaviorRelayBacked_UserDefault {
//    init(key: String, defaultValue: V.WrappedValue) {
//        T
//        self.init(getProjectedWrapper: T.init(wrappedValue:),
//                  firstWrapper: UserDefault(key: key, defaultValue: defaultValue))
//    }
//}
//
//@propertyWrapper
//struct PropertyWrappersApplier22<T: NestableProjectedPropertyWrapper, V: NestablePropertyWrapper> where T.WrappedValue == V.WrappedValue {
//
//    typealias ProjectedValue = T.ProjectedValue
//    typealias WrappedValue = T.WrappedValue
//
//    var projectedValue: ProjectedValue {
//        projectedWrapper.projectedValue
//    }
//
//    var wrappedValue: WrappedValue {
//        get { getWrappedValue() }
//        set { setWrappedValue(newValue) }
//    }
//
//    private let projectedWrapper: T
//    private let firstWrapper: V
//    private let getWrappedValue: () -> WrappedValue
//    private let setWrappedValue: (WrappedValue) -> Void
//
//    init(getFirstWrapper: (WrappedValue) -> V,
//         projectedWrapper: T) {
//
//        self.projectedWrapper = projectedWrapper
//        self.firstWrapper = getFirstWrapper(projectedWrapper.wrappedValue)
//
//        getWrappedValue = {
//            projectedWrapper.wrappedValue
//        }
//
//        setWrappedValue = { [projectedWrapper, firstWrapper] newValue in
//            firstWrapper.wrappedValue = newValue
//            var _newValue = projectedWrapper.newValue
//
//            if let newValue = _newValue {
//                projectedWrapper.wrappedValue = newValue
//                _newValue = firstWrapper.newValue
//            } else {
//                return
//            }
//        }
//    }
//}
//
//extension PropertyWrappersApplier22 where T: WrappedValueInstantiatable, V: WrappedValueInstantiatable {
//    init(wrappedValue: WrappedValue) {
//        self.init(getFirstWrapper: V.init(wrappedValue:), projectedWrapper: T.init(wrappedValue: wrappedValue))
//    }
//}
//
//@propertyWrapper
//struct PropertyWrappersApplier3<T: NestableProjectedPropertyWrapper, V: NestablePropertyWrapper, U: NestablePropertyWrapper> where T.WrappedValue == V.WrappedValue, T.WrappedValue == U.WrappedValue {
//
//    typealias ProjectedValue = T.ProjectedValue
//    typealias WrappedValue = T.WrappedValue
//
//    var projectedValue: ProjectedValue {
//        projectedWrapper.projectedValue
//    }
//
//    var wrappedValue: WrappedValue {
//        get { getWrappedValue() }
//        set { setWrappedValue(newValue) }
//    }
//
//    private let projectedWrapper: T
//    private let firstWrapper: V
//    private let secondWrapper: U
//    private let getWrappedValue: () -> WrappedValue
//    private let setWrappedValue: (WrappedValue) -> Void
//
//    init(getFirstWrapper: (WrappedValue) -> V,
//         getProjectedWrapper: (WrappedValue) -> T,
//         secondWrapper: U) {
//
//        self.secondWrapper = secondWrapper
//        self.projectedWrapper = getProjectedWrapper(secondWrapper.wrappedValue)
//        self.firstWrapper = getFirstWrapper(projectedWrapper.wrappedValue)
//
//        getWrappedValue = {
//            secondWrapper.wrappedValue
//        }
//
//        setWrappedValue = { [projectedWrapper, firstWrapper] newValue in
//            firstWrapper.wrappedValue = newValue
//            var _newValue = projectedWrapper.newValue
//
//            if let newValue = _newValue {
//                projectedWrapper.wrappedValue = newValue
//                _newValue = firstWrapper.newValue
//            } else {
//                return
//            }
//
//            if let newValue = _newValue {
//                secondWrapper.wrappedValue = newValue
//                _newValue = secondWrapper.newValue
//            } else {
//                return
//            }
//        }
//    }
//}
//
//typealias EquitableFilter_BehaviorRelayBacked<Z: Equatable> = PropertyWrappersApplier22<BehaviorRelayBacked<Z>, EquitableFilter<Z>>
//typealias BehaviorRelayBacked_UserDefault<Z> = PropertyWrappersApplier21<BehaviorRelayBacked<Z>, UserDefault<Z>>
//
//
//enum Operation<T> {
//
//    case behaviorRelay
//
//    func getWrapper(wrappedValue: T) -> NestablePropertyWrapper {
//        switch self {
//        case .behaviorRelay: return BehaviorRelayBacked(wrappedValue: wrappedValue)
//        }
//    }
//}
//
//struct BehRelayOperation<T> {
//
//    func getWrapper(wrappedValue: T) -> BehaviorRelayBacked<T> {
//        return BehaviorRelayBacked(wrappedValue: wrappedValue)
//    }
//}
//
//class PropertyWrapperSwitcher<T: Equatable & Codable> {
//
//    enum SwitchType {
//        case behaviorRelayBacked
//        case equatableFilter
//        case lateInitialized
//        case userDefault(key: String, defaultValue: T)
//        case userDefaultCodable(key: String, defaultValue: T)
//    }
//
//    var wrappedValue: T {
//        get {
//            switch type {
//            case .behaviorRelayBacked: return behaviorRelayBacked.wrappedValue
//            case .equatableFilter: return equatableFilter.wrappedValue
//            case .lateInitialized: return lateInitialized.wrappedValue
//            case .userDefault: return userDefault.wrappedValue
//            case .userDefaultCodable: return userDefaultCodable.wrappedValue
//            }
//        }
//
//        set {
//            switch type {
//            case .behaviorRelayBacked: behaviorRelayBacked.wrappedValue = newValue
//            case .equatableFilter: equatableFilter.wrappedValue = newValue
//            case .lateInitialized: lateInitialized.wrappedValue = newValue
//            case .userDefault: userDefault.wrappedValue = newValue
//            case .userDefaultCodable: userDefault.wrappedValue = newValue
//            }
//        }
//    }
//
//    private let type: SwitchType
//    private var behaviorRelayBacked: BehaviorRelayBacked<T>!
//    private var equatableFilter: EquatableFilter<T>!
//    private var lateInitialized: LateInitialized<T>!
//    private var userDefault: UserDefault<T>!
//    private var userDefaultCodable: UserDefaultCodable<T>!
//
//    init(type: SwitchType, wrappedValue: T!) {
//        self.type = type
//
//        switch type {
//        case .behaviorRelayBacked: behaviorRelayBacked = BehaviorRelayBacked(wrappedValue: wrappedValue)
//        case .equatableFilter: equatableFilter = EquatableFilter(wrappedValue: wrappedValue)
//        case .lateInitialized: lateInitialized = LateInitialized()
//        case .userDefault(let key, let defaultValue): userDefault = UserDefault(key: key, defaultValue: wrappedValue ?? defaultValue)
//        case .userDefaultCodable(key: let key, defaultValue: let defaultValue): userDefaultCodable = UserDefaultCodable(key: key, defaultValue: wrappedValue ?? defaultValue)
//        }
//    }
//}
//
//extension PropertyWrapperSwitcher: NestablePropertyWrapper {
//    func setNewValue(_ newValue: T) -> T? {
//        switch type {
//        case .behaviorRelayBacked: return behaviorRelayBacked.setNewValue(newValue)
//        case .equatableFilter: return equatableFilter.setNewValue(newValue)
//        case .lateInitialized: return lateInitialized.setNewValue(newValue)
//        case .userDefault: return userDefault.setNewValue(newValue)
//        case .userDefaultCodable: return userDefaultCodable.setNewValue(newValue)
//        }
//    }
//}
//
//@propertyWrapper
//class PropertyWrapperApplier<T: Equatable & Codable, U: NestableProjectedPropertyWrapper> where U.WrappedValue == T {
//
//    var wrappedValue: T
//
//    init(beforeOperations: [PropertyWrapperSwitcher<T>.SwitchType], projected: U, afterOperations: [PropertyWrapperSwitcher<T>.SwitchType]) {
//        fatalError()
//    }
//}
