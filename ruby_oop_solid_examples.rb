## OOP Principles

# Abstaction

class MobilePhone
    # public unlock 
    def unlock(fingerprint)
        return unlock_phone(fingerprint)
    end

    private

    def unlock_phone(fingerprint)
        # check if fingerprint matches
        # do unlock the phone
        # render the home screen etc. 
    end

    def fingerprint_matches(fingerprint)
        'check if fingerprint matches'
    end

    def unlock_screen
        'unlock screen'
    end

    def render_home_screen
        'render home screen'
    end
end

# Inheritance

class ShopEmployee
    def refills_shelves
        'refills shelves'
    end

    def speaks_to_customers
        'speaks to customers'
    end
end

class ShopManager < ShopEmployee
    # inherits refills_shelves, since they will also do that
    # inherits speaks_to_customers, since they will also do that

    def opens_shop
        'opens shop'
    end

    def closes_shop
        'closes shop'
    end

    def opens_till
        'opens till'
    end

    def closes_till
        'closes till'
    end
end

# Encapsulation

class Document
    def initialize(name)
      @name = name
    end
  
    def set_name(name)
      @name = name
    end

    def get_name
      @name
    end
end

d = Document.new('cover letter')
d.name
# => 'name1'
d.name = 'Kims cover letter' 
# => error
d.set_name('Kims cover letter')
d.name
# => 'Kims cover letter'

# Polymorphism

class Person
    def greet
        return 'Hello'
    end
end

person = Person.new
person.greet
# => 'Hello'

class EnglishPerson < Person
end

english_person = EnglishPerson.new
english_person.greet
# => 'Hello'

class GermanPerson < Person
    def greet
        return 'Hallo, Guten Tag'
    end
end

german_person = GermanPerson.new
german_person.greet
# => 'Hallo, Guten Tag'

class JunglePerson < Person
    def greet
        return @hand.wave || @hand.shake
    end
end

jungle_person = JunglePerson.new
jungle_person.greet
# => waves hand or shakes hand


# Dependency injection

# bad example, not using dependency injection results us in having our not respecting DRY and SRP principles.
# Our methods are responsible also for instantiating a Waterpipe.
class House
    def take_shower
        water_pipe = Waterpipe.new

        water_pipe.give_water
    end

    def get_glass_of_water
        water_pipe = Waterpipe.new

        water_pipe.give_some_water
    end

    def flush_toilet
        water_pipe = Waterpipe.new

        water_pipe.give_some_more_water
    end
end

# better example, we inject the dependency (Waterpipe) into our class, so it always comes with it this resulting us
# being able to keep our code DRY and respect SRP too.
class House
    def initialize(water_pipe = Waterpipe.new)
        @water_pipe = water_pipe
    end

    def take_shower
        @water_pipe.give_water
    end

    def get_glass_of_water
        @water_pipe.give_some_water
    end

    def flush_toilet
        @water_pipe.give_some_more_water
    end
end

# Open/Closed Principle

# the scenario here is that we are generating payslips, but then later we have to start generating a different kind 
# of payslip. We can start filling the code with if elses but this would be a bad pattern, because 
# we would be modifying our class which is against the Open/Closed Principle.
class PayslipGenerator
    def initialize(employee, month)
      @employee = employee
      @month = month
    end
  
    def generate_payslip
      # Code to read from database,
      # generate payslip
      if employee.contractor?
          # generate payslip for contractor
      else
          # generate a normal payslip
      end
      # and write it to a file
    end
end

# instead we can create separate PayslipGenerator classes
class ContractorPayslipGenerator
    def initialize(employee, month)
      @employee = employee
      @month = month
    end
  
    def generate
      # Code to read from the database,
      # generate payslip
      # and write it to a file
    end
end

class FullTimePayslipGenerator
    def initialize(employee, month)
      @employee = employee
      @month = month
    end
  
    def generate
      # Code to read from the database,
      # generate payslip
      # and write it to a file
    end
end

# and then in our initial PayslipGenerator class, we could be calling the generate function 
# on the respective PayslipGenerator ( Contractor or FullTime)
GENERATORS = {
  'full_time' => FullTimePayslipGenerator,
  'contractor' => ContractorPayslipGenerator
}

class PayslipGenerator
  def initialize(employee, month)
    @employee = employee
    @month = month
  end

  def generate_payslip
    # Code to read from database,
    # generate payslip
    GENERATORS[employee.type].new(employee, month).generate()
    # and write it to a file
  end
end


# Liskov Substitution Principle

class Response
    # Response
end

class JsonRespone < Response
    # JsonResponse
end

# although Ruby doesn't do any typehinting, I am trying to represent that down here. 
response = Response.new()
json_response = JsonRespone.new()

# see how our send_response function is expecting a Response type parameter to be passed in.
# LSP says that we should be able to then pass in a JsonResponse type in too, since it is a child class
# of the Response class and this should not break the application
def send_response(Response response): Response
    return response
end

# Interface Segregation Principle

# Ruby doesn't use interfaces, but if I were to explain it with Ruby, I would use the following example.
# A supercar will not be using a shift_gear_with_gear_stick but it still inherits it so it would be against this principle.
# Probably a better solution here would be to have a AutomaticCar < Car and a ManualCar < Car and then
# both would be able to implement their own ways to switch gears.

class Car
    def shift_gear_with_gear_stick(from, to)
        # shift gear
    end
end

class Van < Car
    # inherits shift_gear_with_gear_stick
end

class Supercar < Car
    # it is forced to inherit shift_gear_with_gear_stick but its actually automatic so it doesn't really need it.

    # it has to implement its own way to shift gears
    def shift_gear_with_paddles(up_or_down)
        # shift gear with paddles
    end
end

# Dependency Inversion principle

# here we are violating the principle, since we're tightly coupling Base64Hasher and PasswordService
class PasswordService
    def initialize
        @hasher = Base64Hasher.new()
    end

    def hash_password(passowrd)
        @hasher.hash_password(password)
    end
end

# so let's decouple it here and then let the client inject the hasher service needed within the constructor

class PasswordService
    def initialize(password_hasher)
        @password_hasher = password_hasher
    end

    def hash_password(password)
        @password_hasher.hash_password(password)
    end
end

# now we can easily change the hashing algorithm since our service does not care about the algorithm, it's on the client
# to choose it. We don't depend on the concrete implementation, we instead depend on the abstraction.