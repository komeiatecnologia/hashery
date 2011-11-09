require 'lemon'
require 'ae'
require 'ae/legacy' # bacause imitation BasicObject sucks

require 'hashery/open_cascade'

testcase OpenCascade do
  include AE::Legacy::Assertions

  class_method :new do
    OpenCascade.new(:a=>1)
  end

  class_method :[] do
    test "initialization" do
      o = OpenCascade[:a=>1,:b=>2]
      assert_equal(1, o.a)
      assert_equal(2, o.b)
    end
  end

  class_method :[] do
    test "mutli-depth lookup" do
      o = OpenCascade[:a=>1,:b=>2,:c=>{:x=>9}]
      assert_equal(9, o.c.x)
    end
  end

  method :[] do
    test "basic assignment" do
      o = OpenCascade.new
      o[:a] = 1
      assert_equal(1, o.a)
    end
  end

  method :[]= do
    test "basic assignment with primed OpenCascade" do
      o = OpenCascade[:a=>1]
      o[:b] = 2
      o.to_h.assert == {:a=>1,:b=>2}
    end
  end

  method :to_a do
    test do
      o = OpenCascade[:a=>1,:b=>2]
      assert_equal([[:a,1], [:b,2]], o.to_a)
    end
  end

  method :to_h do
    test do
      o = OpenCascade[:a=>1]
      assert_equal({:a=>1}, o.to_h)
    end
  end

  method :merge! do
    test do
      o = OpenCascade[:f0=>"f0"]
      h = { :h0=>"h0" }
      r = OpenCascade[:f0=>"f0", :h0=>"h0"]
      assert_equal(r, o.merge!(h))
      assert_equal({:f0=>"f0", :h0=>"h0"}, h.merge(o))
    end
  end

  method :update do
    test do
      o = OpenCascade[:f1=>"f1"]
      o.update(:h1=>"h1")
      o.assert == OpenCascade[:f1=>"f1", :h1=>"h1"]
    end
  end

  method :method_missing do
    test "writer and reader" do
      o = OpenCascade.new
      10.times{ |i| o.__send__("n#{i}=", 1 ) }
      10.times{ |i| assert_equal(1, o.__send__("n#{i}")) }
    end
  end

end

testcase Hash do

  method :update do
    test "hash can be updated by OpenCascade" do
      o = OpenCascade[:f1=>"f1"]
      h = {:h1=>"h1"}
      h.update(o)
      h.assert == {:f1=>"f1", :h1=>"h1"}
    end
  end

end