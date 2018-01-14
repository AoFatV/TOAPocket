using System.Data;
using TOAPocket.DataAccess;

namespace TOAPocket.BusinessLogic
{
    public class BLPainter
    {
        DAPainter daPainter = new DAPainter();

        public DataSet GetPainter(string search)
        {
            return daPainter.GetPainter(search);
        }

        public DataSet GetPainterById(string painterNo)
        {
            return daPainter.GetPainterById(painterNo);
        }

        public bool UpdatePainter(string painterNo, string maxReceive, string updateBy)
        {
            return daPainter.UpdatePainter(painterNo, maxReceive, updateBy);
        }

        public DataSet GetCustomerArea()
        {
            return daPainter.GetCustomerArea();
        }

        public DataSet GetOccupation()
        {
            return daPainter.GetOccupation();
        }

        public DataSet GetIncome()
        {
            return daPainter.GetIncome();
        }

    }
}