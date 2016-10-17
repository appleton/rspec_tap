require "ostruct"
require "spec_helper"
require "rspec_tap/formatter"

RSpec.describe RspecTap::Formatter do
  let(:output) { StringIO.new }
  subject(:formatter) { described_class.new(output) }

  describe "#start" do
    subject(:start) { formatter.start(OpenStruct.new(count: 2)) }

    it "outputs TAP 13" do
      start
      expect(output.string).to include("TAP version 13")
    end

    it "outputs a test plan" do
      start
      expect(output.string).to include("1..2")
    end
  end

  shared_examples_for "a test line" do
    it { is_expected.to include(notification.example.description) }
    it do
      is_expected.to include(formatter.instance_variable_get(:@progress_count).to_s)
    end

    context "a nested example group" do
      let(:parent_groups) do
        [
          OpenStruct.new(description: "my subgroup"),
          OpenStruct.new(description: "My group")
        ]
      end

      it { is_expected.to include("My group my subgroup") }
    end
  end

  describe "#example_passed" do
    before do
      formatter.instance_variable_set(
        :@example_group, OpenStruct.new(parent_groups: parent_groups)
      )
      formatter.example_passed(notification)
    end

    subject(:output_string) { output.string }

    let(:parent_groups) { [] }

    let(:notification) do
      OpenStruct.new(
        example: OpenStruct.new(description: "An test")
      )
    end

    it { is_expected.to start_with("ok") }
    it_behaves_like "a test line"
  end

  describe "#example_failed" do
    before do
      formatter.instance_variable_set(
        :@example_group, OpenStruct.new(parent_groups: parent_groups)
      )
      formatter.example_failed(notification)
    end

    subject(:output_string) { output.string }

    let(:parent_groups) { [] }

    let(:notification) do
      OpenStruct.new(
        example: OpenStruct.new(description: "An test"),
        message_lines: ["Failed for a reason", "", "expected true", "got false"]
      )
    end

    it { is_expected.to start_with("not ok") }
    it_behaves_like "a test line"
  end

  describe "#example_pending" do
    before do
      formatter.instance_variable_set(
        :@example_group, OpenStruct.new(parent_groups: parent_groups)
      )
      formatter.example_pending(notification)
    end

    subject(:output_string) { output.string }

    let(:parent_groups) { [] }

    let(:notification) do
      OpenStruct.new(
        example: OpenStruct.new(description: "An test")
      )
    end

    it { is_expected.to start_with("ok") }
    it { is_expected.to end_with("# SKIP\n") }
    it_behaves_like "a test line"
  end

  describe "#dump_failures" do
    it "no-ops" do
      expect { formatter.dump_failures }.to_not change { output.string }
    end
  end
end
