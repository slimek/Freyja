package freyja.mvc 
{
    public class Model 
    {
        private var m_shifting : String = "";  // 通知 controller 要轉移到此 model
    
        public function Model()
        {
        }
     
        public function ShiftFromModel( model : Model ) : void
        {
            ;  // 這個函式通常會由衍生類別覆寫
        }
     
        public function MainLoop() : void
        {
            ;  // 這個函式通常會由衍生類別覆寫
        }

        protected function TriggerShifting( modelName : String ) : void
        {
            m_shifting = modelName;
        }

        internal function TakeShifting() : String
        {
            var shifting : String = m_shifting;
            m_shifting = "";
            return shifting;
        }
     
    }

}