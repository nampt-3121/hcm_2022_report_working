require "rails_helper"

RSpec.describe RelationshipsController, type: :controller do
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

  describe "GET #new" do
    it_behaves_like "not logged for get method", "new"

    context "when user logged" do
      it "with filter users" do
        sign_in user_admin
        params = {
          filter: {
            email_cont: user.email
          }
        }
        get :new, params: params
        expect(assigns(:users).pluck(:id)).to eq([user.id])
      end

      it "without filter" do
        sign_in user_admin
        get :new
        expect(assigns(:users).pluck(:id)).to eq([user.id, user_manager.id, user_admin.id, user_singe.id])
      end

      it "render new" do
        sign_in user_admin
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    it_behaves_like "not logged for other method" do
      before do
        post :create, params: {
          relationship: {department: [department.id, department_2.id], user_id: [user.id, user_singe.id]}
        }
      end
    end

    context "when user logged" do
      before {sign_in user_admin}

      context "When create success" do
        before do
          post :create, params: {
            relationship: {department: [department.id, department_2.id], user_id: [user.id, user_singe.id]}
          }
        end

        it "add relationships" do
          # expect(assigns(:relationship)).to eq(Department.last)
        end

        it "show flash success" do
          expect(5).to eq Relationship.all.size
        end

        it "redirect to root path" do
          expect(response).to redirect_to new_relationship_path
        end
      end

      context "create relationship failed" do
        before do
          sign_in user_admin
          post :create, params: {
            relationship: {department: [-1], user_id: [user.id, user_singe.id]}
          }
        end

        it "show flash danger" do
          expect(flash.now[:danger]).to eq "Unvaiable Data"
        end

        it "render templates new" do
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "not logged for other method" do
      before do
        patch :destroy, params: {id: 1}
      end
    end

    context "when user logged" do
      before {sign_in user_admin}

      it "delete success" do
        patch :destroy, params: {id: relationship_user.id}
        expect(flash[:success]).to eq "User has been deleted successfully"
      end

      it "delete failed" do
        allow_any_instance_of(Relationship).to receive(:destroy).and_return(false)
        patch :destroy, params: {id: relationship_user.id}
        expect(flash[:danger]).to eq "Delete failed"
      end
    end
  end

  describe "PATCH update/:id" do
    it_behaves_like "not logged for other method" do
      before do
        patch :update, params: {
          role: "manager",
          id: relationship_user.id
        }
      end
    end

    context "when user logged" do
      before {sign_in user_admin}

      it "when confirm report success" do
        patch :update, params: {
          role: "manager",
          id: relationship_user.id
        }
        expect(flash[:success]).to eq "User has been updated successfully"
      end

      it "when confirm report failed" do
        patch :update, params: {
          role: "nil",
          id: relationship_user.id
        }
        expect(flash[:danger]).to eq "Could not update role"
      end
    end
  end
end
