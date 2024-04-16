# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Herd do
  describe '#has?' do
    let(:user) { create(:user) }
    let(:herd) { create(:herd, captain: user) }

    context 'when user is a member of the herd' do
      it 'returns true' do
        expect(herd.has?(user)).to be true
      end
    end

    context 'when user is not a member of the herd' do
      let(:another_user) { create(:user) }

      it 'returns false' do
        expect(herd.has?(another_user)).to be false
      end
    end
  end
end
