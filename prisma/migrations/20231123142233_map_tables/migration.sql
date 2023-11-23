/*
  Warnings:

  - You are about to drop the `Contribution` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Payment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Transaction` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Contribution" DROP CONSTRAINT "Contribution_transactionId_fkey";

-- DropForeignKey
ALTER TABLE "Contribution" DROP CONSTRAINT "Contribution_userId_fkey";

-- DropForeignKey
ALTER TABLE "_userOwner" DROP CONSTRAINT "_userOwner_A_fkey";

-- DropForeignKey
ALTER TABLE "_userOwner" DROP CONSTRAINT "_userOwner_B_fkey";

-- DropForeignKey
ALTER TABLE "_userReceiver" DROP CONSTRAINT "_userReceiver_A_fkey";

-- DropForeignKey
ALTER TABLE "_userReceiver" DROP CONSTRAINT "_userReceiver_B_fkey";

-- DropTable
DROP TABLE "Contribution";

-- DropTable
DROP TABLE "Payment";

-- DropTable
DROP TABLE "Transaction";

-- DropTable
DROP TABLE "User";

-- CreateTable
CREATE TABLE "Users" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "fullName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "hash" TEXT NOT NULL,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transactions" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "type" TEXT[] DEFAULT ARRAY['expense', 'income']::TEXT[],
    "name" TEXT,
    "category" TEXT,
    "amount" DECIMAL(65,30) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "currency" TEXT,

    CONSTRAINT "Transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payments" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "userOwnerId" INTEGER NOT NULL,
    "userReceiverId" INTEGER NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "currency" TEXT,

    CONSTRAINT "Payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contributions" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "transactionId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "percentage" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Contributions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_email_key" ON "Users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Users_hash_key" ON "Users"("hash");

-- AddForeignKey
ALTER TABLE "Contributions" ADD CONSTRAINT "Contributions_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transactions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contributions" ADD CONSTRAINT "Contributions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_userOwner" ADD CONSTRAINT "_userOwner_A_fkey" FOREIGN KEY ("A") REFERENCES "Payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_userOwner" ADD CONSTRAINT "_userOwner_B_fkey" FOREIGN KEY ("B") REFERENCES "Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_userReceiver" ADD CONSTRAINT "_userReceiver_A_fkey" FOREIGN KEY ("A") REFERENCES "Payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_userReceiver" ADD CONSTRAINT "_userReceiver_B_fkey" FOREIGN KEY ("B") REFERENCES "Users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
