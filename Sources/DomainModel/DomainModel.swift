struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    init (amount: Int, currency: String) {
        self.amount = amount
        if (currency == "USD" || currency == "GBP" || currency == "EUR" || currency == "CAN") {
            self.currency = currency
        } else {
            print("wrong")
            self.currency = "USD"
        }
    }
    
    func convert (_ currency: String) -> Money {
        var newMoney = Money(amount: 0, currency: currency)
        if (self.currency == currency) {
            return self
        }
        if (self.currency == "USD") {
            if (currency == "GBP") {
                newMoney.amount = Int(self.amount / 2)
            } else if (currency == "EUR") {
                newMoney.amount = Int((Double(self.amount) * 1.5))
            } else if (currency == "CAN") {
                newMoney.amount = Int((Double(self.amount) * 1.25))
            }
        } else if (self.currency == "GBP") {
            newMoney.currency = "USD"
            newMoney.amount = Int(self.amount * 2)
            return newMoney.convert(currency)
        } else if (self.currency == "EUR") {
            newMoney.currency = "USD"
            newMoney.amount = Int(Double(self.amount)/1.5)
            return newMoney.convert(currency)
        }
        else if (self.currency == "CAN") {
            newMoney.currency = "USD"
            newMoney.amount = Int(Double(self.amount)/1.25)
            return newMoney.convert(currency)
        }
        return newMoney
    }
    
    func add (_ second: Money) -> Money {
        var newMoney = Money(amount: 0, currency: second.currency)
        if (self.currency == second.currency) {
            newMoney.amount = self.amount + second.amount
        } else {
            let temp = self.convert(second.currency)
            newMoney.amount = temp.amount + second.amount
        }
        return newMoney
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title : String
    var type : JobType
    
    init (title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome (_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let temp):
            return Int(temp * Double(hours))
        case .Salary(let temp):
            return Int(temp)
        }
    }
    
    func raise (byAmount: Double) {
        switch self.type {
        case .Hourly(let temp):
            self.type = .Hourly(temp + byAmount)
        case .Salary(let temp):
            self.type = .Salary(temp + UInt(byAmount))
        }
    }
    
    func raise (byPercent: Double) {
        switch self.type {
        case .Hourly(let temp):
            var please = Double(temp) * byPercent
            self.type = .Hourly(temp + Double(UInt(please)))
        case .Salary(let temp):
            var please = Double(temp) * byPercent
            self.type = .Salary(temp + UInt(please))
        }
    }

}

////////////////////////////////////
// Person
//
public class Person {
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    {
        didSet {
            if age < 18 {
                job = nil
            }
        }
    }
    var spouse : Person? {
        didSet {
            if age < 21 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    
    func toString () -> String {
        var st = "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
        return st
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members : [Person] = []
    
    init (spouse1: Person, spouse2: Person) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
    
    func haveChild (_ child: Person) -> Bool {
        if (members[0].age >= 21 || members[1].age >= 1) {
            members.append(child)
            return true
        }
        return false
    }
    
    func householdIncome () -> Int {
        var total = 0
        for member in members{
            let job = member.job
            if job != nil {
                let salary = job!.calculateIncome(2000)
                total = total + salary
            }
        }
        return total
    }
}
