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

    it "should find it by name" do
      AddedMethods.find(:name => 'some_method').first.should be_eql(@added_method)
      AddedMethods.find_by_name('some_method').first.should be_eql(@added_method)
    end

    it "should find it by class" do
      AddedMethods.find(:class => SomeClass).first.should be_eql(@added_method)
      AddedMethods.find_by_class(SomeClass).first.should be_eql(@added_method)
    end

    it "should find it by either name or class" do
      AddedMethods.find_one_by_name_or_class('some_method').should be_eql(@added_method)
      AddedMethods.find_one_by_name_or_class(SomeClass).should be_eql(@added_method)
    end

    it "should find it conveniently by either name or class" do
      AddedMethods['some_method'].should be_eql(@added_method)
      AddedMethods[SomeClass].should be_eql(@added_method)
    end

    it "should find it by file" do
      AddedMethods.find(:file => __FILE__).first.should be_eql(@added_method)
    end

    it "should find it by regexp" do
      AddedMethods.find(:name => /some_method/).first.should be_eql(@added_method)
    end

    describe "added method" do

      it "should be an AddedMethod" do
        @added_method.should be_an_instance_of(AddedMethods::AddedMethod)
      end

      it "should know its name" do
        @added_method.name.should == 'some_method'
        @added_method[:name].should == 'some_method'
      end

      it "should know its class" do
        @added_method.klass.should == SomeClass
        @added_method[:klass].should == SomeClass
        @added_method[:class].should == SomeClass
      end

      it "should know its file" do
        @added_method.file.should == __FILE__
      end

      it "should know if it's a singleton method" do
        @added_method.should_not be_singleton
      end

      it "should know its source" do
        @added_method.source.should == ["      class SomeClass; def some_method; end; end\n"]
      end

      it "should know its source from Ruby2Ruby" do
        @added_method.r2r_source.should == " [R2R]\ndef some_method\n  # do nothing\nend"
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
