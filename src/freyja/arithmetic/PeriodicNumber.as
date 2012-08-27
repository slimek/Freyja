package freyja.arithmetic 
{
	/**
     * 週期性的 Number，數值在 [0,1)（最小值 0、最大值接近但不等於 1）之間變動。
     */
    public class PeriodicNumber 
    {
        private var m_period: Number = 0;
        private var m_startTime: Number = 0;
        private var m_offset: Number = 0;
        private var m_value: Number = 0;
        

        public function get period() : Number { return m_period; }
        public function get value()  : Number { return m_value; }
            
        public function PeriodicNumber( period: Number, startTime: Number = 0, initialValue: Number = 0 )
        {
            if ( 0 > initialValue || 1 <= initialValue )
            {
                throw ArgumentError( "Initial value must be in range [0, 1)" );
            }
        
            m_period = period;
            m_startTime = startTime;
            m_offset = initialValue;
            m_value = initialValue;
        }
        
        public function Update( nowTime: Number ) : Number
        {
            var value: Number = (( nowTime - m_startTime ) / m_period ) + m_offset;
            m_value = value - Math.floor( value );  // 僅留下小數部分
            return m_value;
        }
    }

}