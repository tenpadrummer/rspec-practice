# letのDRYのためこちらに切り分け
# 今回はcontrollers//tasks_controller_spec.rbで使用している。

RSpec.shared_context "project setup" do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }
  let(:task) { project.tasks.create!(name: "Test task") }
end
