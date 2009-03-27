describe AddedMethods do

  describe "with an added instance method" do

    before :all do
      class SomeClass; def some_method; end; end

      @added_methods = AddedMethods.all_methods[SomeClass].values.flatten
      @added_method  = @added_methods.last
    end

    it "should record it" do
      @added_methods.should have(1).item
    end

    describe "added method" do

      it "should be an AddedMethod" do
        @added_method.should be_an_instance_of(AddedMethods::AddedMethod)
      end

      it "should know its name" do
        @added_method.name.should == 'some_method'
      end

      it "should know its class" do
        @added_method.klass.should == SomeClass
      end

      it "should know its file" do
        @added_method.file.should == __FILE__
      end

      it "should know if it's a singleton method" do
        @added_method.should_not be_singleton
      end

    end

  end

  describe "with an added class method" do

    before :all do
      class SomeClass; def self.some_class_method; end; end

      @added_methods = AddedMethods.all_methods[SomeClass].values.flatten
      @added_method  = @added_methods.last
    end

    it "should record it" do
      @added_methods.should have_at_least(1).item
    end

    describe "added method" do

      it "should be an AddedMethod" do
        @added_method.should be_an_instance_of(AddedMethods::AddedMethod)
      end

      it "should know its name" do
        @added_method.name.should == 'some_class_method'
      end

      it "should know its class" do
        @added_method.klass.should == SomeClass
      end

      it "should know its file" do
        @added_method.file.should == __FILE__
      end

      it "should know if it's a singleton method" do
        @added_method.should be_singleton
      end

    end

  end

end
