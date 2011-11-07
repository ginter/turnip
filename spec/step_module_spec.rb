describe Turnip::StepModule do
  before(:each) do
    Turnip::StepModule.clear_module_registry
  end

  describe '.steps_for' do
    it 'registers for the given tags' do
      Turnip::StepModule.steps_for(:first, :second) {}
      Turnip::StepModule.should be_registered(:first)
      Turnip::StepModule.should be_registered(:second)
    end

    it 'registers an anonymous modle for the given tags' do
      Turnip::StepModule.steps_for(:first) {}
      Turnip::StepModule.module_registry[:first].first.should be_instance_of(Module)
    end

    it 'registers the same module for multiple tags' do
      Turnip::StepModule.steps_for(:first, :second) {}
      Turnip::StepModule.module_registry[:first].first.should eq(Turnip::StepModule.module_registry[:second].first)
    end
  end

  describe '.step_module' do
    subject do
      Turnip::StepModule.step_module do
        def marker; end
      end
    end

    it 'creates an anonymous module' do
      subject.name.should be_nil
    end

    it 'extends the steps DSL' do
      subject.should be_kind_of(Turnip::StepModule::DSL)
    end

    it 'executes the block in the module' do
      subject
      subject.instance_methods.should include(:marker)
    end
  end
end