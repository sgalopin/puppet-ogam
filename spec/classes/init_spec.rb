require 'spec_helper'
describe 'ogam' do
  context 'with default values for all parameters' do
    it { should contain_class('ogam') }
  end
end
