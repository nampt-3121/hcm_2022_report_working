require "rails_helper"

RSpec.describe DepartmentsController, type: :controller do
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

  describe "GET #index" do
    it_behaves_like "not logged for get method", "index"

    context "when user logged" do
      it "with filter reports" do
        sign_in user_admin
        params = {
          filter: {
            name_cont: department.name,
            department: nil,
            name: nil,
            date_created: nil,
            date_reported: nil,
            status: nil
          }
        }
        get :index, params: params
        expect(assigns(:departments).pluck(:id)).to eq([department.id])
      end

      it "without filter" do
        sign_in user_admin
        get :index
        expect(assigns(:departments).pluck(:id)).to eq([department.id, department_2.id])
      end

      it "render index" do
        sign_in user
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET show/:id" do
    it_behaves_like "not logged for other method" do
      before do
        get :show, params: {id: department.id}
      end
    end

    context "when user logged" do
      before {sign_in user}

      context "when department found" do
        it "render show" do
          get :show, params: {id: department.id}
          expect(response).to render_template :show
        end
      end

      context "when no department found" do
        before {get :show, params: {id: -1}}

        it "show flash danger" do
          expect(flash[:danger]).to eq "Department not found"
        end

        it "redirect to root_path" do
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "GET #new" do
    it_behaves_like "not logged for other method" do
      before {get :new}
    end

    context "when user logged" do
      before {sign_in user_admin}

      it "should be constructor" do
        get :new
        expect(assigns(:department)).to be_a_new(Department)
      end

      it "render new" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    it_behaves_like "not logged for other method" do
      before do
        post :create, params: {
          department: { name: "test", description: "test" }
        }
      end
    end

    context "when user logged" do
      before {sign_in user_admin}

      context "When create success" do
        before do
          post :create, params: {
            department: { name: "AAA", description: "test" }
          }
        end

        it "build report success" do
          expect(assigns(:department)).to eq(Department.last)
        end

        it "show flash success" do
          expect(flash[:success]).to eq "Create department Successfully"
        end

        it "redirect to root path" do
          expect(response).to redirect_to department_path(Department.last.id)
        end
      end

      context "create report failed" do
        before do
          sign_in user_admin
          post :create, params: {department: { name: "", description: "test" }}
        end

        it "show flash danger" do
          expect(flash.now[:danger]).to eq "Create department Error"
        end

        it "render templates new" do
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET #edit" do
    it_behaves_like "not logged for get method", "edit", {id: 1}

    context "when user logged" do
      before {sign_in user_admin}

      it "render edit" do
        get :edit, params: {id: department.id}
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH update/:id" do
    it_behaves_like "not logged for other method" do
      before do
        put :update, params: {
          id: department.id, department: { name: "aaa", description: "test" }
        }
      end
    end

    context "when user logged" do
      before {sign_in user_admin}

      context " when update success" do
        before do
          put :update, params: {
            id: department.id, department: { name: "aaa", description: "test" }
          }
        end

        it "update success" do
          expect(assigns(:department)).to eq(Department.find(department.id))
        end

        it "show success message" do
          expect(flash.now[:success]).to eq "Edit Successfully"
        end

        it "redirect to department reports path" do
          expect(response).to redirect_to department_path(department.id)
        end
      end

      context "when update failed" do
        before do
          put :update, params: {
            id: department.id, department: {name: "", description: "test"}
          }
        end

        it "show failure message" do
          expect(flash.now[:danger]).to eq "Edit Failure"
        end

        it "render edit templates" do
          expect(response).to render_template :edit
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
        patch :destroy, params: {id: department.id}
        expect(flash[:success]).to eq "Delete Successfully"
      end

      it "delete failed" do
        allow_any_instance_of(Report).to receive(:destroy).and_return(false)
        patch :destroy, params: {id: department.id}
        expect(flash[:danger]).to eq "Delete Failure"
      end
    end
  end
end
