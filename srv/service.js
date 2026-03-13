const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Cars, Rentals } = this.entities;

    this.after('READ', Rentals, (data) => {
    const rentals = Array.isArray(data) ? data : [data];

    for (const rental of rentals) {
      if (!rental) continue;

      const brand = rental.car?.brand || '';
      const model = rental.car?.model || '';
      const clientName = rental.client?.name || '';

      rental.carDisplay = `${brand} ${model}`.trim();
      rental.clientDisplay = clientName;
    }
  });

  this.before('CREATE', Rentals, async (req) => {
    const { car_ID, startDate, endDate } = req.data;

    if (!car_ID) {
      return req.reject(400, 'É necessário informar um carro para a locação.');
    }

    if (!startDate || !endDate) {
      return req.reject(400, 'É necessário informar a data de início e a data de fim.');
    }

    const start = new Date(startDate);
    const end = new Date(endDate);

    if (end < start) {
      return req.reject(400, 'A data final não pode ser menor que a data inicial.');
    }

    const car = await SELECT.one.from(Cars).where({ ID: car_ID });

    if (!car) {
      return req.reject(404, 'Carro não encontrado.');
    }

    if (car.status === 'Alugado') {
      return req.reject(400, 'Este carro já está alugado e não pode ser locado novamente.');
    }

    if (car.status === 'Manutencao') {
      return req.reject(400, 'Este carro está em manutenção e não pode ser locado.');
    }

    if (car.dailyRate === undefined || car.dailyRate === null) {
      return req.reject(400, 'Este carro não possui diária cadastrada.');
    }

    const diffTime = end.getTime() - start.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    req.data.dailyRate = Number(car.dailyRate);
    req.data.totalAmount = diffDays * Number(car.dailyRate);
  });

  this.after('CREATE', Rentals, async (data) => {
    await UPDATE(Cars)
      .set({ status: 'Alugado' })
      .where({ ID: data.car_ID });
  });

  this.after('UPDATE', Rentals, async (data) => {
    if (data.status === 'Finalizada') {
      const rental = await SELECT.one.from(Rentals).where({ ID: data.ID });

      if (rental && rental.car_ID) {
        await UPDATE(Cars)
          .set({ status: 'Disponivel' })
          .where({ ID: rental.car_ID });
      }
    }
  });

  this.on('finalizarLocacao', Rentals, async (req) => {
    const { params } = req;
    const rentalId = params[0].ID;

    const rental = await SELECT.one.from(Rentals).where({ ID: rentalId });

    if (!rental) {
      return req.reject(404, 'Locação não encontrada.');
    }

    if (rental.status === 'Finalizada') {
      return req.reject(400, 'Esta locação já está finalizada.');
    }

    await UPDATE(Rentals)
      .set({ status: 'Finalizada' })
      .where({ ID: rentalId });

    if (rental.car_ID) {
      await UPDATE(Cars)
        .set({ status: 'Disponivel' })
        .where({ ID: rental.car_ID });
    }

    return { message: 'Locação finalizada com sucesso.' };
  });
});