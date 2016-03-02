require 'rails_helper'

module Renalware::Feeds
  RSpec.describe MessageParser do
    describe "#parse" do
       let(:raw_message) { <<-RAW
MSH|^~\&|ICE|RWH|TIE|RWH|20130311194243||ORU^R01|20130311194243847+0|P|2.4|||AL|AL||| PID|1|8888888888|8||RABBIT^ROGER^^^||19700101|M|||7 RABBIT HOLE^STEVENAGE^HERTS^^SG1 0RR|SG1 0RR|||||||8888888888|||||||||||N PV1|1||8A|||||LINE^LINES|LINE^LINES|||||||||||| ORC|RE|8278028|||||||201303111744|||LINE^LINES|8A^^^^^^^^Ward 8A|||||||| OBR|1|8278028|0013L492233|CA^CALCIUM/ALB.^LC|||201303111625|||||||201303111744|T034^BLOOD|LINE^LINES||||0013L492233||201303111927||820^Blood Sciences|F|||||||||| OBX|1|ST|ALB^Albumin^LC||30|g/L|35-50|L|||F|||201303111625|0013L492233| OBX|2|ST|CA^Calcium^LC||2.12|mmol/l|2.2-2.65|L|||F|||201303111625|0013L492233| OBX|3|ST|CACO^Adjusted Calcium^LC||2.32|mmol/l|2.2-2.6||||F|||201303111625|0013L492233| OBR|2|8278028|0013L492233|OCC^CELL COUNT^LC|||201303111625|||||||201303111744|T034^BLOOD|LINE^LINES||||0013L492233||201303111927||820^Blood Sciences|F|||||||||| OBX|1|ST|WBC^WBC^LC||15.6|10|4-11|H|||F|||201303111625|0013L492233| OBX|2|ST|RBC^RBC^LC||2.68|10|3.8-4.8|L|||F|||201303111625|0013L492233| OBX|3|ST|HB2^HB^LC||89|g/L|120-150|L|||F|||201303111625|0013L492233| OBX|4|ST|HCT^Hct^LC||0.269|L/L|0.36-0.46|L|||F|||201303111625|0013L492233| OBX|5|ST|MCV^MCV^LC||101|fl|78-101||||F|||201303111625|0013L492233| OBX|6|ST|MCH^MCH^LC||33.2|pg|27-32|H|||F|||201303111625|0013L492233| OBX|7|ST|MHC2^MCHC^LC||330.0|g/L|315-345||||F|||201303111625|0013L492233| OBX|8|ST|PLTS^Platelets^LC||158|10|150-400||||F|||201303111625|0013L492233| OBX|9|ST|NEUT^Neutrophils^LC|| 92% 14.35|10|2-7|A|||F|||201303111625|0013L492233| OBX|10|ST|LYMP^Lymphocytes^LC||  5%  0.78|10|1-3.5|A|||F|||201303111625|0013L492233| OBX|11|ST|MONO^Monocytes^LC||  2%  0.31|10|0.2-1||||F|||201303111625|0013L492233| OBX|12|ST|EOS^Eosinophils^LC||  1%  0.16|10|0.02-0.5||||F|||201303111625|0013L492233| OBX|13|ST|BASO^Basophils^LC||  0%  0.00|10|0.02-0.1|A|||F|||201303111625|0013L492233| OBR|3|8278028|0013L492233|CRP^C REACTIVE PROTEIN^LC|||201303111625|||||||201303111744|T034^BLOOD|LINE^LINES||||0013L492233||201303111927||820^Blood Sciences|F|||||||||| OBX|1|ST|CRP^C Reactive protein^LC||17|mg/l|0-5|H|||F|||201303111625|0013L492233| OBR|4|8278028|0013L492233|LFT^LIVER FUNCTION TEST^LC|||201303111625|||||||201303111744|T034^BLOOD|LINE^LINES||||0013L492233||201303111927||820^Blood Sciences|F|||||||||| OBX|1|ST|BILI^Bilirubin^LC||5|umol/l|0-21||||F|||201303111625|0013L492233| OBX|2|ST|ALKP^Alkaline Phosphatase^LC||72|IU/l|30-130||||F|||201303111625|0013L492233| OBX|3|ST|ALT^ALT^LC||17|IU/l|5-55||||F|||201303111625|0013L492233| OBR|5|8278028|0013L492233|UE^UE^LC|||201303111625|||||||201303111744|T034^BLOOD|LINE^LINES||||0013L492233||201303111927||820^Blood Sciences|F|||||||||| OBX|1|ST|NA^Sodium^LC||135|mmol/l|133-146||||F|||201303111625|0013L492233| OBX|2|ST|K^Potassium^LC||6.0|mmol/l|3.5-5.3|H|||F|||201303111625|0013L492233| OBX|3|ST|UREA^Urea^LC||15.8|mmol/l|2.5-7.8|H|||F|||201303111625|0013L492233| OBX|4|ST|CREA^Creatinine^LC||165|umol/l|45-84|H|||F|||201303111625|0013L492233| OBX|5|ST|EGFR^eGFR (MDRD Calculation)^LC||27|ml/min|||||F|||201303111625|0013L492233| OBX|6|ST|BEGF^eGFR (If patient is black)^LC||33|ml/min|||||F|||201303111625|0013L492233| NTE|1|T|eGFR is an estimate only.| NTE|2|T|It has not been validated in ethnic groups other| NTE|3|T|than whites or blacks, or in those older than 70.| NTE|4|T|Its use is not recommended in pregnancy,| NTE|5|T|or during acute changes in kidney function.|
        RAW
       }

      it "returns a message" do
        message = subject.parse(raw_message)

        expect(message).to be_a(MessageWrapper)
      end

      it "assigns the event code to the message" do
        message = subject.parse(raw_message)

        expect(message.type).to eq("ORU^R01")
      end

      it "assigns the payload to the message" do
        message = subject.parse(raw_message)

        expect(message.to_s).to eq(raw_message)
      end
    end
  end
end
