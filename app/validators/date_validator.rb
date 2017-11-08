class DateValidator < ActiveModel::Validator
  def validate(record)
    valid_from = record.valid_from
    valid_through = record.valid_through
    if valid_through.present? && valid_from.present?
      if valid_through < valid_from
        record.errors[:valid_through] << "valid_from must be less than valid_through"
      end
    end
  end
end
