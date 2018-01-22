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

        public bool UpdatePainter(string painterId, string painterNo, string name, string surname, string mobile,
            string areaCode, string areaDesc, string address, string job, string income, string updateBy)
        {
            return daPainter.UpdatePainter(painterId, painterNo, name, surname, mobile, areaCode, areaDesc, address, job, income, updateBy);
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