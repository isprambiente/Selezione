require 'test_helper'

class CareerTest < ActiveSupport::TestCase
  test 'valid from factory' do
    career = build :career
    assert career.valid?
    assert career.save
  end

  # relations
  test 'belongs to request' do
    career = create :career
    assert_equal 'Request', career.request.class.name
  end

  # Validation
  test 'request must be present' do
    career = build :career, request: nil
    assert_not career.valid?
    career.request = create :request
    assert career.valid?
    assert career.save
  end
  test 'employer must be present' do
    career = build :career, employer: nil
    assert_not career.valid?
    career.employer = 'employer'
    assert career.valid?
    assert career.save
  end
  test 'category must be present' do
    career = build :career, category: ''
    assert_not career.valid?
    career.category = 'ti'
    assert career.valid?
    assert career.save
  end
  test 'description must be present' do
    career = build :career, description: ''
    assert_not career.valid?
    career.description = 'description'
    assert career.valid?
    assert career.save
  end
  test 'start_on must be present' do
    career = build :career, start_on: nil
    assert_not career.valid?
    career.start_on = Date.today - 1.year
    assert career.valid?
    assert career.save
  end
  test 'start_on must be minor of stop_on' do
    career = build :career, start_on: Date.today.-(9.month), stop_on: Date.today.-(11.month)
    assert_not career.valid?
    career.start_on = Date.today - 12.month
    assert career.valid?
    assert career.save
  end
  test 'stop_on must be present' do
    career = build :career, stop_on: nil
    assert_not career.valid?
    career.stop_on = Date.today
    assert career.valid?
    assert career.save
  end
  test 'stop_on must be minor or equal to stop_at' do
    request = create :request
    career = build :career, request: request, stop_on: request.stop_at + 1.days
    assert_not career.valid?
    career.stop_on = request.stop_at
    assert career.valid?
    career.stop_on = request.stop_at - 1.days
    assert career.valid?
    assert career.save
  end
  test 'length must be major of 14' do
    career = build :career, start_on: Date.today - 16.days, stop_on: Date.today - 2.days
    assert_not career.valid?
    career.stop_on = Date.today - 1.days
    assert career.valid?
    assert career.save
  end
  test 'readonly model if contest is sended' do
    career = create :career
    assert career.update employer: 'ok'
    career.request.update status: :sended
    assert career.valid?
    assert_raise(Exception) { assert_not career.update(value: 'employer') }
    assert career.readonly?
  end

end
