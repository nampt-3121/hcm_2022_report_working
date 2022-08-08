require "rails_helper"

RSpec.describe "Relationships", type: :controller do
  let!(:user) {FactoryBot.create :user}
  let!(:user_manager) {FactoryBot.create :user, role: :normal}
  let!(:user_admin) {FactoryBot.create :user, role: :admin}
  let!(:user_singe) {FactoryBot.create :user, role: :normal}
  let!(:department) {FactoryBot.create :department}
  let!(:department_2) {FactoryBot.create :department}
  let!(:relationship_user) {FactoryBot.create :relationship, user_id: user.id, department_id: department.id, role_type: :employee}
  let!(:relationship_manager) {FactoryBot.create :relationship, user_id: user_manager.id, department_id: department.id, role_type: :manager}
  let!(:report_1) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id}
  let!(:report_2) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id}
  let!(:report_3) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id, report_status: :confirmed}
  let!(:report_4) {FactoryBot.create :report, from_user_id: user_singe.id, to_user_id: user_manager.id, department_id: department.id}

end
