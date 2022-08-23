require "test_helper"

class QualificationTest < ActiveSupport::TestCase
  test 'valid from factory' do
    qualification = build :qualification
    assert qualification.valid?
    assert qualification.save
  end

  # relations
  test 'belongs to request' do
    qualification = create :qualification
    assert_equal 'Request', qualification.request.class.name
  end

  # Validations
  test 'presence of request'  do
    qualification = build :qualification, request: nil
    assert_not qualification.valid?
    qualification.request = create :request
    assert qualification.valid?
    assert qualification.save
  end

  test 'presence of title' do
    qualification = build :qualification, title: ''
    assert_not qualification.valid?
    qualification.title = 'title'
    assert qualification.valid?
    assert qualification.save
  end
  
  test 'presence of year' do
    qualification = build :qualification, year: nil
    assert_not qualification.valid?
    qualification.year = ''
    assert_not qualification.valid?
    qualification.year = 2022
    assert qualification.valid?
    assert qualification.save
  end

  test 'presence of istitute' do
    qualification = build :qualification, istitute: ''
    assert_not qualification.valid?
    qualification.istitute = 'istitute'
    assert qualification.valid?
    assert qualification.save
  end
  
  test 'presence of vote if votable?' do
    qualification = build :qualification, vote: '', category: :dsg
    assert qualification.votable?
    assert_not qualification.valid?
    qualification.vote = '10'
    assert qualification.valid?
    assert qualification.save
  end

  test 'presence of vote_type if votable?' do
    qualification = build :qualification, vote_type: '', category: :dsg
    assert qualification.votable?
    assert_not qualification.valid?
    qualification.vote_type = '10'
    assert qualification.valid?
    assert qualification.save
  end

  test 'inclusion of vote_type in VOTE_TYPE if votable?' do
    qualification = build :qualification, vote_type: 'wrong_type', category: :dsg
    assert qualification.votable?
    assert_not qualification.valid?
    qualification.vote_type = '10'
    assert qualification.valid?
    assert qualification.save
  end
  
  test 'presence of duration if category_training?' do
    qualification = build :qualification, duration: '', category: :training
    assert qualification.category_training?
    assert_not qualification.valid?
    qualification.duration = '10'
    assert qualification.valid?
    assert qualification.save
  end

  test 'inclusion of duration_type in DURATION_TYPE if category_training?' do
    qualification = build :qualification, duration_type: 'wrong', category: :training
    assert qualification.category_training?
    assert_not qualification.valid?
    qualification.duration_type = 'ore'
    assert qualification.valid?
    assert qualification.save
  end

  # method
  test 'votable return true if category require a vote' do
    q = build(:qualification, category: :dsg)
    assert q.votable?
    q = build(:qualification, category: :training)
    assert_not q.votable?
  end

  test 'clear_superfluous_data! remove duration and duration_type if votable' do
    q = build(:qualification, category: :dsg)
    assert q.duration.present?
    assert q.duration_type.present?
    q.clear_superfluous_data!
    assert_not q.duration.present?
    assert_not q.duration_type.present?
  end

  test 'clear_superfluous_data! remove vote and vote_type unless votable' do
    q = build(:qualification, category: :phd)
    assert q.vote.present?
    assert q.vote_type.present?
    q.clear_superfluous_data!
    assert_not q.vote.present?
    assert_not q.vote_type.present?
  end

  test 'before_validation run clear_superfluous_data!' do
    q = build(:qualification, category: :phd)
    assert q.vote.present?
    assert q.vote_type.present?
    q.save
    assert_not q.vote.present?
    assert_not q.vote_type.present?
  end
end
