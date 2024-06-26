# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.runners' do
    before do
      stub_get('/runners', 'runners')
    end

    context 'without extra queries' do
      before do
        @runner = Gitlab.runners
      end

      it 'gets the correct resource' do
        expect(a_get('/runners')).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end

    context 'with queries' do
      before do
        stub_get('/runners?type=instance_type', 'runners')
        @runner = Gitlab.runners(type: :instance_type)
      end

      it 'gets the correct resource' do
        expect(a_get('/runners').with(query: { type: :instance_type })).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end
  end

  describe '.all_runners' do
    before do
      stub_get('/runners/all', 'runners')
    end

    context 'without extra queries' do
      before do
        @runner = Gitlab.all_runners
      end

      it 'gets the correct resource' do
        expect(a_get('/runners/all')).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end

    context 'with queries' do
      before do
        stub_get('/runners/all?type=instance_type', 'runners')
        @runner = Gitlab.all_runners(type: :instance_type)
      end

      it 'gets the correct resource' do
        expect(a_get('/runners/all').with(query: { type: :instance_type })).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runner).to be_a Gitlab::PaginatedResponse
        expect(@runner.first.id).to eq(6)
        expect(@runner.first.description).to eq('test-1-20150125')
      end
    end
  end

  describe '.runner' do
    before do
      stub_get('/runners/6', 'runner')
      @runners = Gitlab.runner(6)
    end

    it 'gets the correct resource' do
      expect(a_get('/runners/6')).to have_been_made
    end

    it 'returns a response of a runner' do
      expect(@runners).to be_a Gitlab::ObjectifiedHash
      expect(@runners.id).to eq(6)
      expect(@runners.description).to eq('test-1-20150125')
    end
  end

  describe '.update_runner' do
    before do
      stub_put('/runners/6', 'runner_edit').with(body: { description: 'abcefg' })
      @runner = Gitlab.update_runner(6, description: 'abcefg')
    end

    it 'gets the correct resource' do
      expect(a_put('/runners/6').with(body: { description: 'abcefg' })).to have_been_made
    end

    it 'returns an updated response of a runner' do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.description).to eq('abcefg')
    end
  end

  describe '.delete_runner' do
    before do
      stub_delete('/runners/6', 'runner_delete')
      @runner = Gitlab.delete_runner(6)
    end

    it 'gets the correct resource' do
      expect(a_delete('/runners/6')).to have_been_made
    end

    it 'returns a response of the deleted runner' do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
    end
  end

  describe '.runner_jobs' do
    before do
      stub_get('/runners/1/jobs?status=running', 'runner_jobs')
      @jobs = Gitlab.runner_jobs(1, status: :running)
    end

    it 'gets the correct resource' do
      expect(a_get('/runners/1/jobs').with(query: { status: :running })).to have_been_made
    end
  end

  describe '.project_runners' do
    before do
      stub_get('/projects/1/runners', 'project_runners')
      @runners = Gitlab.project_runners(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/runners')).to have_been_made
    end

    it 'returns a paginated response of runners' do
      expect(@runners).to be_a Gitlab::PaginatedResponse
      expect(@runners.first.id).to eq(8)
      expect(@runners.first.description).to eq('test-2-20150125')
    end
  end

  describe '.project_enable_runner' do
    before do
      stub_post('/projects/1/runners', 'runner')
      @runner = Gitlab.project_enable_runner(1, 6)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/runners')).to have_been_made
    end

    it 'returns a response of the enabled runner' do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
      expect(@runner.description).to eq('test-1-20150125')
    end
  end

  describe '.project_disable_runner' do
    before do
      stub_delete('/projects/1/runners/6', 'runner')
      @runner = Gitlab.project_disable_runner(1, 6)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/1/runners/6')).to have_been_made
    end

    it 'returns a response of the disabled runner' do
      expect(@runner).to be_a Gitlab::ObjectifiedHash
      expect(@runner.id).to eq(6)
      expect(@runner.description).to eq('test-1-20150125')
    end
  end

  describe '.group_runners' do
    before do
      stub_get('/groups/9/runners', 'group_runners')
    end

    context 'without extra queries' do
      before do
        @runners = Gitlab.group_runners(9)
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/9/runners')).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runners).to be_a Gitlab::PaginatedResponse
      end
    end

    context 'with queries' do
      before do
        stub_get('/groups/9/runners?type=instance_type', 'group_runners')
        @runner = Gitlab.group_runners(9, type: :instance_type)
      end

      it 'gets the correct resource' do
        expect(a_get('/groups/9/runners').with(query: { type: :instance_type })).to have_been_made
      end

      it 'returns a paginated response of runners' do
        expect(@runner).to be_a Gitlab::PaginatedResponse
      end
    end
  end

  describe '.register_runner' do
    before do
      stub_post('/runners', 'register_runner_response').with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125', description: 'Some Description', active: true, locked: false })
      @register_runner_response = Gitlab.register_runner('6337ff461c94fd3fa32ba3b1ff4125', description: 'Some Description', active: true, locked: false)
    end

    it 'gets the correct resource' do
      expect(a_post('/runners')
        .with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125', description: 'Some Description', active: true, locked: false })).to have_been_made
    end

    it 'returns correct response for the runner registration' do
      expect(@register_runner_response.token).to eq('6337ff461c94fd3fa32ba3b1ff4125')
    end
  end

  describe 'create_runner' do
    it 'creates the correct group runner call' do
      stub_post('/user/runners', 'create_group_runner_response.json').with(body: { runner_type: 'group_type', group_id: 12_345, tag_list: %w[foo bar], description: 'desc', locked: false })

      @runner_response = Gitlab.create_group_runner(12_345, tag_list: %w[foo bar], description: 'desc', locked: false)

      expect(a_post('/user/runners').with(body: { runner_type: 'group_type', group_id: 12_345, tag_list: %w[foo bar], description: 'desc', locked: false })).to have_been_made

      expect(@runner_response.to_h).to eq({ 'id' => 12_345, 'token' => 'glrt-kyahzxLaj4Dc1jQf4xjX', 'token_expires_at' => nil })
    end

    it 'creates the correct project runner call' do
      stub_post('/user/runners', 'create_project_runner_response.json').with(body: { runner_type: 'project_type', project_id: 56_789, tag_list: %w[foo bar], paused: true, maximum_timeout: 60 })

      @runner_response = Gitlab.create_project_runner(56_789, tag_list: %w[foo bar], paused: true, maximum_timeout: 60)

      expect(a_post('/user/runners').with(body: { runner_type: 'project_type', project_id: 56_789, tag_list: %w[foo bar], paused: true, maximum_timeout: 60 })).to have_been_made

      expect(@runner_response.to_h).to eq({ 'id' => 56_789, 'token' => 'glrt-kyahzxLaj4Dc1jQf4xjX', 'token_expires_at' => nil })
    end

    it 'creates the correct instance runner call' do
      stub_post('/user/runners', 'create_instance_runner_response.json').with(body: { runner_type: 'instance_type', tag_list: %w[foo bar], maintenance_note: 'note', run_untagged: false, access_level: 'ref_protected' })

      @runner_response = Gitlab.create_instance_runner(tag_list: %w[foo bar], maintenance_note: 'note', run_untagged: false, access_level: 'ref_protected')

      expect(a_post('/user/runners').with(body: { runner_type: 'instance_type', tag_list: %w[foo bar], maintenance_note: 'note', run_untagged: false, access_level: 'ref_protected' })).to have_been_made

      expect(@runner_response.to_h).to eq({ 'id' => 9171, 'token' => 'glrt-kyahzxLaj4Dc1jQf4xjX', 'token_expires_at' => nil })
    end
  end

  describe '.delete_registered_runner' do
    before do
      stub_delete('/runners', 'empty').with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125' })
      Gitlab.delete_registered_runner('6337ff461c94fd3fa32ba3b1ff4125')
    end

    it 'gets the correct resource' do
      expect(a_delete('/runners')
        .with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125' })).to have_been_made
    end
  end

  describe '.verify_auth_registered_runner' do
    before do
      stub_post('/runners/verify', 'empty').with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125' })
      Gitlab.verify_auth_registered_runner('6337ff461c94fd3fa32ba3b1ff4125')
    end

    it 'gets the correct resource' do
      expect(a_post('/runners/verify')
        .with(body: { token: '6337ff461c94fd3fa32ba3b1ff4125' })).to have_been_made
    end
  end
end
