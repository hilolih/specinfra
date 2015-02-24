require 'spec_helper'

class Test
  extend Specinfra::Process::Module::Runmqsc
end
describe Specinfra::Process::Module::Runmqsc do
  before do
    @result = <<-EOF
     1 : dis chstatus(*) WHERE (CHLTYPE EQ CLUSRCVR)
AMQ8417: チャネル状況の内容を表示します。
   CHANNEL(CH_CL_GK_GZ02)                  CHLTYPE(CLUSRCVR)
   CONNAME(10.40.1.12)                     CURRENT
   RQMNAME(QM_SZMST01)                     STATUS(RUNNING)
   SUBSTATE(RECEIVE)
AMQ8417: チャネル状況の内容を表示します。
   CHANNEL(CH_CL_GK_GZ02)                  CHLTYPE(CLUSRCVR)
   CONNAME(10.40.1.13)                     CURRENT
   RQMNAME(QM_SZMST02)                     STATUS(RUNNING)
   SUBSTATE(RECEIVE)
AMQ8417: チャネル状況の内容を表示します。
   CHANNEL(CH_CL_GK_SZMST02)               CHLTYPE(CLUSSDR)
   CONNAME(10.40.1.22(1415))               CURRENT
   RQMNAME(QM_SZMST02)                     STATUS(RUNNING)
   SUBSTATE(MQGET)                         XMITQ(SYSTEM.CLUSTER.TRANSMIT.QUEUE)
AMQ8417: チャネル状況の内容を表示します。
   CHANNEL(CH_CL_GK_SZMST01)               CHLTYPE(CLUSSDR)
   CONNAME(10.40.1.21(1414))               CURRENT
   RQMNAME(QM_SZMST01)                     STATUS(RUNNING)
   SUBSTATE(MQGET)                         XMITQ(SYSTEM.CLUSTER.TRANSMIT.QUEUE)
MQSC コマンドを 1 つ読み取りました。
構文エラーがあるコマンドはありません。
有効な MQSC コマンドはすべて処理されました。
EOF
  end
  describe '#runmqsc_result' do
    it "parse test" do
      re = Test.runmqsc_result(@result)
      expect(re.size).to eq 4
      expect(re.first["CHANNEL"]).to eq "CH_CL_GK_GZ02"
      expect(re.first["CONNAME"]).to eq "10.40.1.12"
      expect(re.last["CHANNEL"]).to eq "CH_CL_GK_SZMST01"
      expect(re.last["CONNAME"]).to eq "10.40.1.21(1414)"
    end
  end

end

